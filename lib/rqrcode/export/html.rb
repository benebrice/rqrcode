# frozen_string_literal: true

module RQRCode
  module Export
    module HTML
      #
      # Use this module to HTML-ify the QR code if you just want the default HTML
      def as_html(options = {})
        ['<table>', rows.as_html(options), '</table>'].join
      end

      private

      def rows
        Rows.new(@qrcode)
      end

      class Rows < Struct.new(:qr)
        def as_html(options = {})
          rows.map{|r| r.as_html(options)}.join
        end

        def rows
          qr.modules.each_with_index.map { |qr_module, row_index| Row.new(qr, qr_module, row_index) }
        end
      end

      class Row < Struct.new(:qr, :qr_module, :row_index)
        def as_html(options = {})
          style = options.dig(:style, :tr, :css) || ''
          classes = options.dig(:style, :tr, :class) || ''
          ["<tr style=\"#{style}\" class=\"#{html_class(classes)}\">", cells.map{|c| c.as_html(options)}.join, '</tr>'].join
        end

        def cells
          qr.modules.each_with_index.map { |qr_module, col_index| Cell.new(qr, col_index, row_index) }
        end

        def html_class(classes)
          classes
        end
      end

      class Cell < Struct.new(:qr, :col_index, :row_index)
        def as_html(options = {})
          style = options.dig(:style, :td, :css) || ''
          classes = options.dig(:style, :td, :class) || ''
          "<td style=\"#{style}\" class=\"#{html_class(classes)}\"></td>"
        end

        def html_class(classes)
          res = qr.checked?(row_index, col_index) ? 'black' : 'white'
          res + ' ' + classes
        end
      end
    end
  end
end

RQRCode::QRCode.send :include, RQRCode::Export::HTML
