class BuildJob < ActiveRecord::Base
  include CloneTree
  belongs_to :changeset
  serialize :log
  serialize :build_spec
  validates :container_id, uniqueness: true, :allow_blank => true, :allow_nil => true

  def self.from_spec!(build_spec, changeset)
    self.create!(changeset: changeset, build_spec: build_spec, slug: build_spec.slug)
  end

  def running?
    finished_at.blank?
  end

  def run_time
    (finished_at || Time.now) - started_at
  end

  def provision_path!
    clone_tree(changeset.provision_path!, provision_path)
    provision_path
  end

  def provision_path
    @_provision_path ||= [changeset.provision_path, [self.class.name, self.id].join('@') ].join('-')
  end

  rails_admin do
    configure :log do
      pretty_value do
        me = bindings[:object]
        inner = me.log.map do |line|
            kind, msg = *line
            ['<li class="log-line log-', kind, '">', msg ,'</li>'].join
        end.join("\n")
        ['<ul class="log">', inner, '</ul>'].join("\n").html_safe
      end
    end
  end

end
