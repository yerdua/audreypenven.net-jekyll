module Jekyll

  class ProjectPage < Page
    def initialize(site, base, dir, project_key)
      @site = site
      @base = base
      @dir = dir
      @project = project_key
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'photography_project.html')
      self.data = site.data['projects'][@project]
      self.data['project_key'] = @project
      self.data['image_folder'] = "/images/photography/#{@project}"
      self.data['partials_folder'] = "/_projects/#{@project}"
    end
  end

  class ProjectPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'photography_project'
        dir = 'photography/projects'
        site.data['projects'].each_key do |project_key|
          site.pages << ProjectPage.new(site, site.source, File.join(dir, project_key), project_key)
        end
      end
    end
  end

end