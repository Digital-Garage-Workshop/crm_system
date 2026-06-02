class CustomMarkdownRenderer < CommonMarker::HtmlRenderer
<<<<<<< HEAD
  # TODO: let move this regex from here to a config file where we can update this list much more easily
  # the config file will also have the matching embed template as well.
  YOUTUBE_REGEX = %r{https?://(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([^&/]+)}
  LOOM_REGEX = %r{https?://(?:www\.)?loom\.com/share/([^&/]+)}
  VIMEO_REGEX = %r{https?://(?:www\.)?vimeo\.com/(\d+)}
  MP4_REGEX = %r{https?://(?:www\.)?.+\.(mp4)}
  ARCADE_REGEX = %r{https?://(?:www\.)?app\.arcade\.software/share/([^&/]+)}
=======
  CONFIG_PATH = Rails.root.join('config/markdown_embeds.yml')

  def self.config
    @config ||= YAML.load_file(CONFIG_PATH)
  end

  def self.embed_regexes
    @embed_regexes ||= config.transform_values { |embed_config| Regexp.new(embed_config['regex']) }
  end

  def table(node)
    out('<div class="tableWrapper">')
    super
    out('</div>')
  end
>>>>>>> upstream/develop

  def text(node)
    content = node.string_content

    if content.include?('^')
      split_content = parse_sup(content)
      out(split_content.join)
    else
      out(escape_html(content))
    end
  end

  def link(node)
    return if surrounded_by_empty_lines?(node) && render_embedded_content(node)

<<<<<<< HEAD
    # If it's not YouTube or Vimeo link, render normally
    super
  end

  private

=======
    # If it's not a supported embed link, render normally
    super
  end

  def image(node)
    src = escape_href(node.url)
    width = extract_image_width(src)
    plain do
      out(%(<img src="#{src}"))
      out(' alt="', :children, '"')
      out(%( title="#{escape_html(node.title)}")) if node.title.present?
      out(%( style="width: #{width}; max-width: 100%; height: auto;")) if width
      out(' />')
    end
  end

  private

  def extract_image_width(src)
    query = URI.parse(src).query
    raw = query && CGI.parse(query)['cw_image_width']&.first
    return unless raw =~ /\A(\d+)px\z/

    px = Regexp.last_match(1).to_i
    "#{px}px" if px.between?(1, 2000)
  rescue URI::InvalidURIError
    nil
  end

>>>>>>> upstream/develop
  def surrounded_by_empty_lines?(node)
    prev_node_empty?(node.previous) && next_node_empty?(node.next)
  end

  def prev_node_empty?(prev_node)
    prev_node.nil? || node_empty?(prev_node)
  end

  def next_node_empty?(next_node)
    next_node.nil? || node_empty?(next_node)
  end

  def node_empty?(node)
    (node.type == :text && node.string_content.strip.empty?) || (node.type != :text)
  end

  def render_embedded_content(node)
    link_url = node.url
<<<<<<< HEAD
    embedding_methods = {
      YOUTUBE_REGEX => :make_youtube_embed,
      VIMEO_REGEX => :make_vimeo_embed,
      MP4_REGEX => :make_video_embed,
      LOOM_REGEX => :make_loom_embed,
      ARCADE_REGEX => :make_arcade_embed
    }

    embedding_methods.each do |regex, method|
      match = link_url.match(regex)
      if match
        out(send(method, match))
        return true
      end
    end

    false
=======
    embed_html = find_matching_embed(link_url)

    return false unless embed_html

    out(embed_html)
    true
  end

  def find_matching_embed(link_url)
    self.class.embed_regexes.each do |embed_key, regex|
      match = link_url.match(regex)
      next unless match

      return render_embed_from_match(embed_key, match)
    end

    nil
  end

  def render_embed_from_match(embed_key, match_data)
    embed_config = self.class.config[embed_key]
    return nil unless embed_config

    template = embed_config['template']
    # Use gsub (not format) so CSS `%` values in templates don't need escaping.
    # Captured values are HTML-escaped since they land inside HTML attribute contexts.
    match_data.named_captures.each do |var_name, value|
      template = template.gsub("%{#{var_name}}", CGI.escapeHTML(value))
    end
    template
>>>>>>> upstream/develop
  end

  def parse_sup(content)
    content.split(/(\^[^\^]+\^)/).map do |segment|
      if segment.start_with?('^') && segment.end_with?('^')
        "<sup>#{escape_html(segment[1..-2])}</sup>"
      else
        escape_html(segment)
      end
    end
  end
<<<<<<< HEAD

  def make_youtube_embed(youtube_match)
    video_id = youtube_match[1]
    %(
      <div style="position: relative; padding-bottom: 62.5%; height: 0;">
       <iframe
        src="https://www.youtube-nocookie.com/embed/#{video_id}"
        frameborder="0"
        style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen></iframe>
      </div>
    )
  end

  def make_loom_embed(loom_match)
    video_id = loom_match[1]
    %(
      <div style="position: relative; padding-bottom: 62.5%; height: 0;">
        <iframe
         src="https://www.loom.com/embed/#{video_id}"
         frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen
         style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
      </div>
    )
  end

  def make_vimeo_embed(vimeo_match)
    video_id = vimeo_match[1]
    %(
      <div style="position: relative; padding-bottom: 62.5%; height: 0;">
       <iframe
        src="https://player.vimeo.com/video/#{video_id}?dnt=true"
        frameborder="0"
        allow="autoplay; fullscreen; picture-in-picture"
        allowfullscreen
        style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
       </div>
    )
  end

  def make_video_embed(link_url)
    %(
      <video width="640" height="360" controls>
        <source src="#{link_url}" type="video/mp4">
        Your browser does not support the video tag.
      </video>
    )
  end

  def make_arcade_embed(arcade_match)
    video_id = arcade_match[1]
    %(
    <div style="position: relative; padding-bottom: 62.5%; height: 0;">
      <iframe
        src="https://app.arcade.software/embed/#{video_id}"
        frameborder="0"
        webkitallowfullscreen
        mozallowfullscreen
        allowfullscreen
        allow="fullscreen"
        style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">
      </iframe>
    </div>
  )
  end
=======
>>>>>>> upstream/develop
end
