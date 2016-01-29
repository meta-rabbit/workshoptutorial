class Scrape
 attr_accessor :title, :hotness, :image_url, :rating, :director,
 :genre, :release_date, :runtime, :synopsis, :failure

 def scrape_new_movie(url)
   begin
     doc = Nokogiri::HTML(open(url))
     doc.css('script').remove
     self.title = doc.at("//h1[@class = 'title hidden-xs']").text
     self.hotness = doc.at("//span[@itemprop = 'ratingValue']").text.to_i
     self.image_url = doc.at_css('#movie-image-section img')['src']
     self.rating = doc.at("//td[@itemprop = 'contentRating']").text.tidy_bytes
     self.director = doc.at("//td[@itemprop = 'director']").css('a').first.text.tidy_bytes
     self.genre = doc.at("//span[@itemprop = 'genre']").text.tidy_bytes
     #self.release_date = doc.at("//td[@itemprop = 'datePublished']").text.to_date
     self.runtime = doc.at("//time[@itemprop = 'duration']").text.tidy_bytes
     self.synopsis = doc.css('#movieSynopsis').text.tidy_bytes
     return true
   rescue Exception => e
     self.failure = "Something went wrong with the scrape"
   end
   end
def save_movie
   movie = Movie.new(
     title: self.title,
     hotness: self.hotness,
     image_url: self.image_url,
     synopsis: self.synopsis,
     rating: self.rating,
     genre: self.genre,
     director: self.director,
     #release_date: self.release_date,
     runtime: self.runtime
     )
   movie.save
  end
end 
