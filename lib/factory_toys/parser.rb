module FactoryToys
  class Parser # Feature Factory
    attr_accessor :elements

    def elements
      @elements ||= {}
    end

    def initialize(data)
      rows = self.split_by_row(data)
      rows = self.process_elements(rows)
      elements[:base] = (rows.empty? ? '' : rows.join("\n") )
    end

    protected
    def process_elements(rows)
      row = 0
      while rows.size > row
        rows, row = self.process_element(rows, row)
      end
      return rows
    end

    def split_by_row(data)
      data.split("\n")
    end

    def process_element(rows, row)
      if rows[row] =~ /^[\s]*([^\s]+)[\s]*=[\s]*<<-([^\s]+)[\s]*$/
        name, start_text = $1, $2
        self.make_instance_variable(rows, row)
        rows = self.extract_element(rows, row, name, start_text)
        return rows, row
      else
        self.make_instance_variable(rows, row)
        return rows, row + 1
      end
    end

    def make_instance_variable(rows, row)
      if rows[row] =~ /^([\s]*)([^\s]+)([\s]*)=(.*)$/
        unless [':','"',"'",'@'].include?($2[0..0]) or
            ['>'].include?($4[0..0])
          rows[row] = "#{$1}@#{$2}#{$3}=#{$4}"
        end
      end
    end

    def extract_element(rows, row, name, start_text)
      end_row = find_closure_text(rows, row, start_text)
      elements[name.to_sym] = self.element_string(rows[row..end_row])
      (row == 0 ? [] : rows[0..row-1]) + rows[end_row+1..-1]
    end

    def element_string(element_rows)
      element_rows.map! do |row|
        if row =~ /^[\s]*<< ([^\s]+)[\s]*$/
          raise UnknownInlineError, $1 unless elements[$1.to_sym]
          elements[$1.to_sym].split("\n")[1..-2]
        else
          row
        end
      end
      return element_rows.join("\n")
    end

    def find_closure_text(rows, row, start_text)
      rows[row..-1].each_with_index do |row_text, i|
        return row + i if row_text.strip == start_text
      end
      raise FactoryToys::CloseTagNotFoundError
    end
  end
end