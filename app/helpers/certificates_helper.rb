module CertificatesHelper
  def sort_link(attr)
    link_to((ti "table.#{attr}"), sort_params(attr)) + current_mark(attr)
  end

  private

  def sort_params(attr)
    result = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params
    result.merge(sort: attr, sort_dir: sort_dir(attr), only_path: true)
  end

  def sort_dir(attr)
    current_sort?(attr) && params[:sort_dir] == 'asc' ? 'desc' : 'asc'
  end

  def current_sort?(attr)
    params[:sort] == attr.to_s
  end

  def current_mark(attr)
    if current_sort?(attr)
      # rubocop:disable Rails/OutputSafety
      (sort_dir(attr) == 'asc' ? ' &darr;' : ' &uarr;').html_safe
      # rubocop:enable Rails/OutputSafety
    else
      ''
    end
  end
end
