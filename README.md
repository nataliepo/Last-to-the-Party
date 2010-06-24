Which TypePad blogs are you missing out on?  Let's see what your friends are Favoriting the most.


# Installation

Grab this perl script, but also snag http://github.com/sixapart/perl-typepad-api and place it at the same level as party.pl (so use lib 'perl-typepad-api/lib/'; will play nicely).


# API Key
You have to have a set of API keys in order to look up this data.  It's free, and any TypePad user can get one: http://www.typepad.com/account/access/developer . Note the Consumer Key and Consumer Secret


# Usage

       perl party.pl nataliepo myconsumerkey myconsumersecret <optional report threshold>
       
I only show blogs that have more than 3 Favorites and posts that have more than 2 Favorites.  Don't need to know about the one-offs.
       

# Sample

Here's the party that I (nataliepo) am missing:

      --- FAVORITE BLOG SUMMARY --- 
       [12] this is sippey.com (http://www.sippey.com/)
       [12] FAKELOCKE.COM (http://www.fakelocke.com/)
       [11] Community: Make A Face
       [11] The Fairy GodKnitter (http://thejoyofsocks.typepad.com/my_weblog/)
       [10] hello typepad (http://hello.typepad.com/hello/)
       [8]  Everything TypePad (http://everything.typepad.com/blog/)
       [7]  nataliepo (http://nataliepo.typepad.com/nataliepo/)
 
 
       --- FAVORITE POST SUMMARY --- 
       [4] "The Rules of NEXT" from blog "nataliepo"
       [2] "I am hated" from blog "The Winter Webb"
       [2] "No more links array" from blog "TypePad Dev Blog"
       [2] "Happy Halloween from your Community Manager. <3" from blog "Everything TypePad"
       [2] "a face" from blog "Make A Face"
       [2] "Thank You, Miz Claire" from blog "Everything TypePad"
       [2] "Will the iPad usher in a golden age of UI design?" from blog "Designing Exceptional Experiences" 


# Caveat
This is only a listing of the favorites from the 50 TypePad Users you most recently started to follow.  Next up is how to fetch the rest of the series (example - page 2 http://api.typepad.com/users/6p00e5539faa3b8833/relationships/@following.js?max-results=50&start-index=50).
