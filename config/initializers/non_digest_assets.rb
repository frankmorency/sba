# Adding path/file to the whitelist will allow assets:precompile to create the digest and non-digest file
NonStupidDigestAssets.whitelist = []
# Match any file path that contains "ckeditor{any number of any characters other than newline}/"
NonStupidDigestAssets.whitelist.push(/ckeditor.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/uswds.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/landing-icons.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/font.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/alerts.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/datatable.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/favicons.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/pdfjs.*[\/]/i)
NonStupidDigestAssets.whitelist.push(/social-icons.*[\/]/i)

