# frozen_string_literal: true

class FormComponent < ViewComponent::Base
  def initialize(title:, size: 'default')
    super
    @title = title
    @size = size_class_list(size)
  end

  def size_class_list(size)
    default = 'lg:w-4/12 md:w-6/12'
    size == 'small' ? 'xl:w-3/12 ' + default : default
  end
end
