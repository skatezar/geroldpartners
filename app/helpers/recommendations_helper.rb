module RecommendationsHelper
  def truncate_rich_html(html, word_limit)
    return "" if html.blank?

    fragment = Nokogiri::HTML5.fragment(html.to_s)
    state = { remaining: word_limit, truncated: false }
    walk_truncate(fragment, state)
    fragment.to_html.html_safe
  end

  private

  def walk_truncate(node, state)
    node.children.to_a.each do |child|
      if state[:remaining] <= 0
        child.remove
        state[:truncated] = true
        next
      end

      if child.text?
        words = child.text.scan(/\S+/)
        if words.size <= state[:remaining]
          state[:remaining] -= words.size
        else
          take = words.first(state[:remaining])
          state[:remaining] = 0
          state[:truncated] = true
          suffix = take.any? ? "…" : ""
          child.content = take.join(" ") + suffix
        end
      else
        walk_truncate(child, state)
      end
    end
  end
end
