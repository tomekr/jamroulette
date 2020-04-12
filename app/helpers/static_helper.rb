module StaticHelper
  def toggle_target_list(list, allowed)
    # Convert ["Church Organ", "Bass"]  to "churchOrgan bass"
    (list & allowed).map do |tag|
      tag.parameterize.underscore.camelize(:lower)
    end.join(' ')
  end
end
