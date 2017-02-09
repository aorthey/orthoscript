#!/usr/bin/perl
use Image::Magick;
use warnings;
use strict;


my $font = "/usr/share/fonts/truetype/freefont/FreeSans.ttf";
#my $font_path = "/usr/share/fonts/truetype/msttcorefonts/";
#my $font_type = "arial.ttf";
my $background_folder = "/usr/share/backgrounds/favorites/";
my @bg_images = <$background_folder*>;
my $image_name = "textured_background.png";
my $image = Image::Magick->new;
 
my $vocabulary = "/home/orthez/Dropbox/Misc/vocabulary.txt";
open FILE, "<$vocabulary" or die $!;
my @str = <FILE>;

my $choosen_bg_image = int(rand(scalar(@bg_images)));
$image->ReadImage($bg_images[$choosen_bg_image]);
print "Used image $choosen_bg_image";
my $y='y';
my $x='x';

my ($width, $height) = $image->Get('width','height');
print " size: $width x $height";

my $choosen_vocabulary = $str[int(rand(scalar(@str)))];
my $x_c = 0.4*$width;
my $y_c = 0.8*$height;
my $p_size = int(0.03*$height);
my $x_start = $x_c-50;
my $y_start = $y_c-0.05*$height;
my $x_end = $width;
my $y_end = $y_c + 0.05*$height;
my $points = "$x_start,$y_start $x_end,$y_end";
$image->Draw(strike => 'white', primitive => 'rectangle', points => $points);
$image -> Annotate(
  text     => "$choosen_vocabulary", 
  stroke   =>"white", 
  fill     =>"white", 
  $x        =>$x_c,
  $y        =>$y_c, 
  pointsize=> $p_size, 
  font     =>$font);

close FILE;
$image->Write($image_name);
#system("display $image_name");
system("cp $image_name ~/");
#system("gconftool-2 --type string --set /desktop/gnome/background/picture_filename ~/$image_name");

system("gsettings set org.gnome.desktop.background picture-uri file:///home/orthez/$image_name");

