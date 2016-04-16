#
# require 'duplicate_deleter'; DuplicateDeleter.new.run
#

require 'awesome_print'

class DuplicateDeleter

  attr_accessor :messages, :deleted_posts, :total_posts

  def initialize
    @messages       = []
    @deleted_posts  = []
    @total_posts    = Wordpress::Post.count
  end

  def run
    remove_posts
    remove_term_relationships
    remove_taxonomies
    remove_terms
    write_report
  end

  def write_report
    messages.unshift("Total Posts: #{total_posts}")
    messages.unshift("Deleted Posts: #{deleted_posts.size}")
    puts messages.join("\n")
  end

  def remove_posts

    # posts where guid matches unwanted language stem
    guid_posts.each do |post|
      delete_post(post)
    end

    # posts where parent term is language term
    # we want to remove
    language_posts.each do |post|
      delete_post(post)
    end

  end

  def guid_posts
    @guid_posts ||= url_stems.flat_map do |stem|
      Wordpress::Post.published.where("guid LIKE '%#{stem}%'")
    end
  end

  def language_posts
    slug_taxonomies.flat_map(&:objects)
  end

  def delete_post(post)
    if post
      messages << "Trashed '#{post.title}' '#{post.guid}'"
      post.update_column(:post_status, :trash)
      deleted_posts << post
    else
      messages << "Skipped '#{post.title}' '#{post.guid}'"
    end

  end

  def remove_term_relationships
    slug_terms.flat_map(&:term_taxonomies).flat_map(&:term_relationships).each do |rel|
      if rel.object.blank?
        rel.delete
      end
    end
  end

  def remove_taxonomies
    slug_terms.flat_map(&:term_taxonomies).each(&:delete)
  end

  def remove_terms
    slug_terms.each do |term|
      messages << "Deleting term #{term.slug}"
      term.delete
    end
  end

  def slug_taxonomies
    @slug_taxonomies ||= slug_terms.flat_map(&:term_taxonomies)
  end

  def slug_terms
    @slug_terms ||= slug_stems.flat_map do |stem|
      slug_terms = Wordpress::Term.where("`slug` LIKE '#{stem}'")
    end
  end

  def slug_stem(stem)
    "%-#{stem}"
  end

  def url_stem(stem)
    "/#{stem}/"
  end

  def url_stems
    language_stems.map{|x| url_stem(x) }
  end

  def slug_stems
    language_stems.map{|x| slug_stem(x) }
  end

  def language_stems
    [
      'es',
      'pt-br',
      'ar',
      'arabic',
      'spanish',
      'portuguese-brazil'
    ]
  end
end
