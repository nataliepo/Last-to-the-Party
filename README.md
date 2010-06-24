Which TypePad blogs are you missing out on?  Let's see what your friends are reading first.


# Installation

Grab this perl script, but also snag http://github.com/sixapart/perl-typepad-api and place it at the same level as party.pl (so use lib 'perl-typepad-api/lib/'; will play nicely).


# API Key
You have to have a set of API keys in order to look up this data.  It's free, and any TypePad user can get one: http://www.typepad.com/account/access/developer . Note the Consumer Key and Consumer Secret


# Usage

       perl party.pl nataliepo myconsumerkey myconsumersecret <optional report threshold>
       
I only show posts that have more than 3 Favorites and blogs that have more than 2 Favorites.  Don't need to know about the one-offs.
       

# Changing the report threshold

