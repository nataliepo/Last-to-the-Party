#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib 'perl-typepad-api/lib/';
use WWW::TypePad;


die "Try again with your typepad username, please.  Usage: \n
   \t perl party.pl ur_username ur_consumer_key ur_consumer_secret \n" if (!$ARGV[0]);

my $username = $ARGV[0];
my $tp = tp($ARGV[1], $ARGV[2]);
my $threshold_default = $ARGV[3];


my %favorite_posts = ();
my %favorite_blogs = ();

my $usr_obj = $tp->users->get($username);

print "\n Hello, " . $usr_obj->{'preferredUsername'} . ". Ready to see which blogs you've been missing?\n";

#my $followers = $usr_obj->followers($username);
my $followers = $tp->users->following($username);


my @keys = keys(%$followers);

print "Now collecting favorites from the " . $followers->{'totalResults'} .
   " TypePad users you follow...\n";

foreach my $follower_item ($followers->{'entries'}) {

   my $limit = 1000;
   foreach my $val (@$follower_item) {
         
      my $favs = $tp->users->favorites(parse_for_id($val->{'target'}->{'id'}));
      
      next if (!$favs);
      my $num_entries = $favs->{'totalResults'};

      if ($num_entries) {
         print "\t ($num_entries) " . $val->{'target'}->{'displayName'} . "...\n";
      }


     foreach my $entry ($favs->{'entries'}) {
         foreach my $item (@$entry) {        

            my $post = "";
            eval{
               $post = $tp->assets->get(parse_for_id($item->{'id'}));
            };
            if ($@){
               next;
            };
            
            my $post_xid = parse_for_id($post->{'id'});            
            my $blog_xid = $post->{'container'}->{'urlId'};

            add_to_favs($post_xid, \%favorite_posts);
            add_to_favs($blog_xid, \%favorite_blogs);
            
         }
      }
      

      $limit--;
      if ($limit <= 0) {       
         print_fav_posts(\%favorite_posts);
         print_fav_blogs(\%favorite_blogs);
         die "Dying early at limit = $limit\n";
      }
   }
}


print_fav_posts(\%favorite_posts);
print_fav_blogs(\%favorite_blogs);




my %temp;

sub print_fav_posts {
   my ($fav_posts_ref) = @_;
   my $threshold = 2 if (!$threshold_default);
   
   print "\n\n--- FAVORITE POST SUMMARY --- \n";
   
   %temp = %$fav_posts_ref;
   
   foreach my $key (sort sortHashDescending keys (%temp)) {
#      print "XID [$key] = " . $temp{$key} . "\n";
   
      next if ($temp{$key} < $threshold);
      
      my $post = $tp->assets->get($key);
      print " [" . $temp{$key} . "]  \"" . $post->{'title'} . "\" from blog \"" . 
         $post->{'container'}->{'displayName'} . "\"\n";
      
   }
}


sub print_fav_blogs {
   my ($fav_blogs_ref) = @_;
   my $threshold = 3 if (!$threshold_default);
   print "\n\n--- FAVORITE BLOG SUMMARY --- \n";
   
   %temp = %$fav_blogs_ref;
   
   foreach my $key (sort sortHashDescending keys (%temp)) {

      next if ($temp{$key} < $threshold);
      my $name = "";
      my $url = "";
      my $blog = "";
      print " [" . $temp{$key} . "] ";
      if ($key =~ /^6a/) {
         print "Blog: ";
         $blog = $tp->blogs->get($key);
         $name = $blog->{'title'};
         $url = $blog->{'homeUrl'};
      }
      else {
         print "Community: ";
         $blog = $tp->groups->get($key);
         $name = $blog->{'displayName'};
         $url = "";
      }
      print "$name";
      if ($url) {
         print " ($url)"; 
      }
      else {
         print " Community";
      }
      print "\n";
   }
}


sub sortHashDescending {
   $temp{$b} <=> $temp{$a};
}


sub print_stats {
   my ($favs_ref) = @_;
   
   foreach my $key (keys(%$favs_ref)) {
      print "XID [$key] = " . $favs_ref->{$key} . "\n";
   }
}

sub tp {  
   my ($key, $secret) = @_; 
    return WWW::TypePad->new(
        consumer_key        => $key,
        consumer_secret     => $secret,
    );
}


sub add_to_favs {
   my ($id, $hash) = @_;
   
   if (!exists($hash->{$id})) {
       $hash->{$id} = 0;
    }
    $hash->{$id} += 1;
   
}

sub parse_for_id {
   my ($str) = @_;
   
   # needs to match
   #  'id' => 'tag:api.typepad.com,2009:6p00e551040fb78834',
   # and
   #  'id : 'tag:typepad,2009:6a00e551040fb788340133ed4f0e1a970b:6p00e551040fb78834'

   my @parts = split(":", $str);

   return $parts[2];
}

1;
