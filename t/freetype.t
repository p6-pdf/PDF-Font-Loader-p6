use v6;
use PDF::Font::Loader :load-font;
use PDF::Lite;
use Test;

my PDF::Lite $pdf .= new;
my $deja = load-font( :file<t/fonts/DejaVuSans.ttf>, :!subset );
my $otf-font = load-font( :file<t/fonts/Cantarell-Oblique.otf> );

$pdf.add-page.text: {
   .font = $deja;
   .text-position = [10, 760];
   .say: 'Hello, world';
   .say: 'WAV', :kern;
   my $s;
   my $n = 0;
   .font = $deja, 8;
   $deja.face.forall-chars: :!load, -> $_ {
       last if .char-code > 19900;
       $s ~= .char-code.chr;
       $s ~= ' ' if $n++ %% 10
   };
   .say: $s, :width(400);
}

$pdf.add-page.text: {
   .text-position = [10, 500];
   .font = $otf-font;
   .say: "Sample Open Type Font";
   .say: 'Bye, for now';
}

# ensure consistant document ID generation
srand(123456);
lives-ok { $pdf.save-as: "t/freetype.pdf"; };

done-testing;

