# wget by default does not cross host download, need to turn on -H.
# Example:
# wget \
#      --recursive \ # Download the whole site.
#      --page-requisites \ # Get all assets/elements (CSS/JS/images).
#      --adjust-extension \ # Save files with .html on the end.
#      --span-hosts \ # Include necessary assets from offsite as well.
#      --convert-links \ # Update links to still work in the static version.
#      --restrict-file-names=windows \ # Modify filenames to work in Windows as well.
#      --domains yoursite.com \ # Do not follow links outside this domain.
#      --no-parent \ # Don't follow links outside the directory you pass in.
#          yoursite.com/whatever/path # The URL to download
#
# httrack can also be used.
# Example:
# Download a whole site without external links at 2 depth
# httrack <site_name>  -O "<output_dir>" --mirrorlinks  --display -r2 --stay-on-same-address
function offlinesavesite --wraps='wget -np -r -k' --description 'alias Download site for offline viewing, no external links'
    wget -np -r -k $argv

end
