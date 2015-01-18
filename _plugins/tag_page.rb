module Jekyll
  class TagPage < Page
    include Convertible
    attr_accessor :site, :pager, :name, :ext
    attr_accessor :basename, :dir, :data, :content, :output
 
    def initialize(site, tag, posts)
      @site = site
      @tag = tag
      self.ext = '.html'
      self.basename = 'index'
      self.content = <<-EOS
<h1>Tag: #{tag}</h1>
<ul>
{% for post in page.posts %}
<li>{{ post.date | date: "%Y-%m-%d" }} &nbsp;&nbsp;&nbsp;&nbsp;<a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul
EOS
      self.data = {
        'layout' => 'default',
        'type' => 'tag',
        'title' => "#{@tag}",
        'posts' => posts
      }
    end
 
    def render(layouts, site_payload)
      payload = Utils.deep_merge_hashes({
        "page" => self.to_liquid,
        "paginator" => pager.to_liquid
      },site_payload)
      do_layout(payload, layouts)
    end
 
    def url
      File.join("/tags", @tag, "index.html")
    end
 
    def to_liquid
      Utils.deep_merge_hashes(self.data, {
                             "url" => self.url,
                             "content" => self.content
                           })
    end
 
    def write(dest_prefix, dest_suffix = nil)
      dest = dest_prefix
      dest = File.join(dest, dest_suffix) if dest_suffix      
      path = File.join(dest, CGI.unescape(self.url))
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |f|        
        f.write(self.output)
      end
      # 将标签文件写入到项目根目录，以便可以在github中看到
      project_home = File.join(dest, "..")
      tag_file_in_project_home = File.join(project_home, CGI.unescape(self.url))
      FileUtils.mkdir_p(File.expand_path(File.dirname(tag_file_in_project_home)))
      File.open(tag_file_in_project_home, 'w') do |f|        
        f.write(self.output)
      end
    end
 
    def html?
      true
    end
  end
end