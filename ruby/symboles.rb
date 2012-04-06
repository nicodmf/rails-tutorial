class Ecolier
  def initialize lang
    @lang = lang
  end
 
  def lang
    @lang.to_s
  end
end
 
Jean = Ecolier.new :fr
Peter = Ecolier.new :en
Karl = Ecolier.new :en
 
puts Jean.lang, Peter.lang, Karl.lang
