module ApplicationHelper
    def list(array)
        array =  array.compact_blank.compact_blank
        return "-" if array.blank?
        array.join(', ')
    end
end
