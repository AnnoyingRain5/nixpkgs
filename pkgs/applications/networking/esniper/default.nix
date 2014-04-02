{ stdenv, fetchurl, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.29.0";

  src = fetchurl {
    url    = "mirror://sourceforge/esniper/esniper-2-29-0.tgz";
    sha256 = "052jfbzm0a88h3hss2vg1vfdrhibjwhbcdnwsbkk5i1z0jj16xxc";
  };

  buildInputs = [openssl curl];

  # Add support for CURL_CA_BUNDLE variable.
  # Fix <http://sourceforge.net/p/esniper/bugs/648/>.
  patches = [ ./find-ca-bundle.patch ];

  postInstall = ''
    sed <"frontends/snipe" >"$out/bin/snipe" \
      -e "2i export PATH=\"$out/bin:${coreutils}/bin:${gawk}/bin:${bash}/bin:${which}/bin:\$PATH\""
    chmod 555 "$out/bin/snipe"
  '';

  meta = {
    description = "Simple, lightweight tool for sniping eBay auctions";
    homepage = "http://esnipe.rsourceforge.net";
    license = "GPLv2";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
