#En utilisant l'extrait 4.9 comme guide, combinez les méthode split 
#(découper), shuffle (mélanger), et join (joindre) pour écrire une 
#fonction qui mélange les lettres d'une chaine de caractère donnée.

def string_shuffle2(s)
  s.split('').shuffle[0..s.length].join("")
end

class String
   def shuffle
     self.split('').shuffle[0..self.length].join("")
   end
end