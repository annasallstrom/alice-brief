#!/usr/bin/ruby

#
# This is booklet.rb by Charles Duan
#
# Copyright 2013 Charles Duan. This program is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Generates a booklet from a PDF file.
#
#
require 'optparse'
require 'ostruct'


class FileProcessor

  def initialize(input_file, output_file, options)
    @input_file = input_file
    @output_file = output_file
    @options = options
  end

  def popen(*args)
    IO.popen("-", 'r+') do |io|
      if io
        yield(io)
      else
        exec(*args.flatten)
      end
    end
  end

  def debug(*args)
    STDERR.puts(*args) if @options.debug
  end

  def input_pages
    return @input_pages if @input_pages

    popen('pdfinfo', @input_file) do |io|
      io.each do |line|
        if line =~ /^Pages:\s+(\d+)/
          @input_pages = $1.to_i
          break;
        end
      end
    end
    raise "Can't get number of pages\n" unless @input_pages
    debug("Input file has #{@input_pages} pages")
    return @input_pages
  end

  def convert_to_ps
    debug("Converting #{@input_file} to PS...")
    popen("pdftops", "-nocenter", @input_file, '-') do |io|
      @input_ps = io.read
    end
    debug("Done.")
  end

  def collect_bboxes
    debug("Collecting bboxes...")
    odd_bboxes, even_bboxes = [], []
    count = 0
    IO.popen(
      "pdftops -nocenter '#{@input_file}' - | gs -sDEVICE=bbox - 2>&1"
    ) do |io|
      io.each do |line|
        if line =~ /^\%\%HiResBoundingBox: (.*) (.*) (.*) (.*)$/
          if count == 0 && @options.counselpress
            count = 2
            next
          end
          count += 1
          (count.even? ? even_bboxes : odd_bboxes).push(
            BBox.new(line)
          ) rescue nil
          STDERR.print("[#{count}]")
          break if count >= 6
        end
      end
      STDERR.print("\n")
    end
    if even_bboxes.empty? && odd_bboxes.empty?
      raise "No page bboxes could be found"
    elsif even_bboxes.empty?
      even_bboxes = odd_bboxes
    elsif odd_bboxes.empty?
      odd_bboxes = even_bboxes
    end
    debug("Done.")
    return odd_bboxes, even_bboxes
  end

  def compute_bboxes
    unless @options.even_bbox && @options.odd_bbox
      odd_bboxes, even_bboxes = collect_bboxes
      @options.even_bbox ||= even_bboxes.reduce(:expand)
      @options.odd_bbox ||= odd_bboxes.reduce(:expand)
      debug("Even side bbox is #{@options.even_bbox.to_s}")
      debug("Odd side bbox is #{@options.odd_bbox.to_s}")
    end
  end

  def compute_transforms
    even_calc = TransformCalculator.new(@options.even_bbox, @options)
    odd_calc = TransformCalculator.new(@options.odd_bbox, @options)

    # Harmonize the ratios so all pages are the same size
    even_calc.ratio = odd_calc.ratio = [ even_calc.ratio, odd_calc.ratio ].min

    # Ordinarily, odd pages are on the right and even pages are on the left.
    # When the --even option is specified, this is reversed.
    if @options.even
      left_calc, right_calc = odd_calc, even_calc
    else
      left_calc, right_calc = even_calc, odd_calc
    end

    @pagespec = "4:#{left_calc.pagespec_0}+#{right_calc.pagespec_1}," +
      "#{left_calc.pagespec_2}+#{right_calc.pagespec_3}"
    debug("Pagespec for pstops:\n#@pagespec")
  end

  def reorder_pages
    pages_per_sheet = @options.tabloid ? 8 : 4
    unless @options.signature % pages_per_sheet == 0
      raise "Error: signature size #{@options.signature} not a multiple of " +
        pages_per_sheet.to_s
    end

    page_array = (1 .. @input_pages).to_a
    page_array.unshift("_") if @options.even
    page_array[1, 0] = '_' if @options.counselpress
    if @options.gluepages
      page_array.unshift("_", "_")
      page_array.push("_", "_")
    end

    total_page_modulo = @options.equalsignatures ?
      @options.signature : pages_per_sheet

    page_array.push(*([ "_" ] * (-page_array.count % total_page_modulo)))

    @reordered_pages = []
    while (page_array.count > @options.signature)
      @reordered_pages.push(
        *reorder_signature(*page_array.shift(@options.signature))
      )
    end
    @reordered_pages.push(*reorder_signature(*page_array))
    debug("Reordered pages: #{@reordered_pages.join(",")}")
  end

  def reorder_signature(*numbers)
    numbers = numbers.flatten
    res = []
    until numbers.empty?
      res.push(numbers.pop, numbers.shift, numbers.shift, numbers.pop)
    end
    return res
  end

  def run_command
    if @options.tabloid
      tabspec = "| pstops '4:0R(0,17in)+3R(0,8.5in),1L(11in,8.5in)+2L(11in,0)'"
      size = "11x17"
    else
      tabspec = ''
      size = 'letter'
    end
    system(
      "pdftops -nocenter '#{@input_file}' - | " +
      "psselect '#{@reordered_pages.join(",")}' | " +
      "pstops '#{@pagespec}' #{tabspec} | " +
      "ps2pdf -dAutoRotatePages=/None -sPAPERSIZE=#{size} - '#{@output_file}'"
    )
    debug("Done with conversion.")
  end

end

class TransformCalculator
  def initialize(bbox, options)
    @bbox = bbox
    @options = options
    @margin = @options.nomargin ? 0.0 : 36.0

    calculate_ratio
  end
  attr_accessor :ratio

  def calculate_ratio
    final_width = @options.paperheight - 2 * @margin
    final_height = @options.paperwidth - 2 * @margin
    height_ratio = final_height / @bbox.height
    width_ratio = final_width / @bbox.width
    @ratio = [ height_ratio, width_ratio, 1 ].min
  end

  def front_x
    @margin + @ratio * @bbox.y2
  end
  def front_left_y
    @margin - @ratio * @bbox.x1
  end
  def front_right_y
    @options.paperheight - @margin - @ratio * @bbox.x2
  end

  def back_x
    @options.paperwidth - @margin - @ratio * @bbox.y2
  end
  def back_left_y
    @options.paperheight - @margin + @ratio * @bbox.x1
  end
  def back_right_y
    @margin + @ratio * @bbox.x2
  end

  def pagespec_0
    "0L@%.5f(%.2f,%.2f)" % [ @ratio, front_x, front_left_y ]
  end
  def pagespec_1
    "1L@%.5f(%.2f,%.2f)" % [ @ratio, front_x, front_right_y ]
  end
  def pagespec_2
    "2R@%.5f(%.2f,%.2f)" % [ @ratio, back_x, back_left_y ]
  end
  def pagespec_3
    "3R@%.5f(%.2f,%.2f)" % [ @ratio, back_x, back_right_y ]
  end

end

class BBox
  def initialize(*args)

    if args.length == 1
      if args[0] =~ /^\%\%HiResBoundingBox: (.*) (.*) (.*) (.*)$/
        args = [ $1, $2, $3, $4 ].map(&:to_f)
      else
        args = args[0].split(",").map { |x| x.to_f * 72 }
      end
    end
    raise "Invalid bounding box #{args.inspect}" unless args.length == 4
    raise "Invalid bounding box #{args.inspect}" unless args[2] > args[0]
    raise "Invalid bounding box #{args.inspect}" unless args[3] > args[1]

    @x1 = args[0]
    @y1 = args[1]
    @x2 = args[2]
    @y2 = args[3]
  end

  def height
    @y2 - @y1
  end

  def width
    @x2 - @x1
  end

  def expand(bbox)
    return BBox.new(
      [ @x1, bbox.x1 ].min,
      [ @y1, bbox.y1 ].min,
      [ @x2, bbox.x2 ].max,
      [ @y2, bbox.y2 ].max
    )

  end
  def to_s
    "(#{@x1}, #{@y1}), (#{@x2}, #{@y2})"
  end

  attr_accessor :x1, :y1, :x2, :y2
end

@options = OpenStruct.new(
  :even_bbox => nil,
  :counselpress => false,
  :odd_bbox => nil,
  :even => false,
  :gluepages => false,
  :debug => false,
  :signature => 24,
  :tabloid => false,
  :nomargin => false,
  :equalsignatures => false,
  :paperwidth => 8.5 * 72,
  :paperheight => 11.0 * 72
)

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename $0} [options] in.pdf [out.pdf]"
  opts.separator("")
  opts.separator("Options:")

  opts.on('-b', '--bbox BBOX', 'Set the bounding box') do |bb|
    @options.odd_bbox = @options.even_bbox = BBox.new(bb)
  end

  opts.on("-c", '--counselpress [PAGE]', 'Deal with Counsel Press briefs') do
    @options.counselpress = true
  end

  opts.on(
    '-e', '--even',
    'Add an extra blank side. document starts on', '  an even page'
  ) { @options.even = true }

  opts.on('-g', '--gluepages', 'Add blank glue pages to either end') do
    @options.gluepages = true
  end

  opts.on('-d', '--debug', 'Print out debugging info') { @options.debug = true }

  opts.on(
    '-s', '--signature NUM', Integer,
    'Number of sides per signature (default 24)'
  ) do |num|
    raise "Invalid number of sides per signature #{num}" unless num % 4 == 0
    @options.signature = num
  end

  opts.on('-t', '--tabloid', 'Output to tabloid paper (8 sides per sheet)') do
    @options.tabloid = true
  end

  opts.on('-m', '--nomargin', 'Suppress extra margin added to pages') do
    @options.nomargin = true
  end

  opts.on(
    '-q', '--equalsignatures',
    "All signatures have the same length",
    '  (by default, the last one may be shorter)'
  ) do
    @options.equalsignatures = true
  end

  opts.on_tail('-h', '--help', 'Show this help') do
    puts opts
    exit
  end
end

opt_parser.parse!(ARGV)

input_file = ARGV[0]
unless input_file
  puts opt_parser.help
  exit 1
end

output_file = ARGV[1] || 'out.pdf'

fp = FileProcessor.new(input_file, output_file, @options)
fp.input_pages
#fp.convert_to_ps
fp.compute_bboxes
fp.compute_transforms
fp.reorder_pages
fp.run_command

