module Jekyll
  class TagPageGenerator < Generator
    safe true
 
    def generate(site)
      #由于在tag_page.rb中添加了手动将标签页写入到项目根目录下的代码，因此在重新生成标签之前，需要将以往的都删掉
      FileUtils.remove_dir(File.absolute_path(".") + "/tags", true)

      site.tags.each do |tag, posts|
        site.pages << TagPage.new(site, tag, posts)
      end
    end
  end
end