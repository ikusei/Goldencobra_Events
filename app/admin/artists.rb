ActiveAdmin.register GoldencobraEvents::Artist, :as => "Artist" do
  menu :parent => "Event-Management", :label => "Kuenstler"

  filter :title, :label => "Name"
  filter :email, :label => "E-Mail"
  filter :description, :label => "Beschreibung"

  index do
    column t('attributes.artist.title'), :sortable => :title do |artist|
      artist.title
    end
    column t('attributes.artist.description') do |artist|
      artist.description
    end
    column t('attributes.artist.email') do |artist|
      artist.email
    end
    column t('attributes.artist.url_link'), :sortable => :url_link do |artist|
      artist.url_link
    end
    column t('attributes.artist.telephone') do |artist|
      artist.telephone
    end
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Muss ausgefuellt werden", label: t('attributes.artist.title')
      f.input :description, :input_html => { :class =>"tinymce"}, label: t('attributes.artist.description')
      f.input :url_link, :label => "Homepage Link", label: t('attributes.artist.url_link')
      f.input :email, label: t('attributes.artist.email')
      f.input :telephone, label: t('attributes.artist.telephone')
    end
    f.inputs "Adresse" do
      f.fields_for :location_attributes, f.object.location do |loc|
        loc.inputs "" do
          loc.input :street, label: t('attributes.location.one.street')
          loc.input :city, label: t('attributes.location.one.city')
          loc.input :zip, label: t('attributes.location.one.zip')
          loc.input :region, label: t('attributes.location.one.region')
          loc.input :country, :as => :string, label: t('attributes.location.one.country')
          # loc.input :lat
          # loc.input :lng
        end
      end
    end
    f.inputs "Bilder" do
      f.has_many :artist_images do |ai|
        ai.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'artist_image_file'} 
      end
    end
    f.inputs "Informationen" do
      f.input :sponsors, :as => :select, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC").map{|c| [c.title, c.id]}, label: t('attributes.sponsor'), :input_html => { "multiple" => "multiple", :class => 'chzn-select', 'data-placeholder' => t('active_admin.events.select_sponsor')} 
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  action_item :only => :show do
    link_to('New Artist', new_admin_artist_path)
  end

  show :title => :title do
    panel "Artist" do
      attributes_table_for artist do
        [:title, :description, :url_link, :email, :telephone, :created_at, :updated_at].each do |aa|
          row aa
        end
      end
    end #end panel artist
    panel "Sponsors" do
      table do
        tr do
          ["Title", "Description", "Homepage", "Size of Sponsorship", "Telephone", "Email"].each do |sa|
            th sa
          end
        end
        artist.sponsors.each do |as|
          tr do
            [as.title, as.description, as.size_of_sponsorship, as.type_of_sponsorship].each do |esa|
              td esa
            end
          end
        end

      end
    end #end panel sponsors
  end

end
