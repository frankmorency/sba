# Be sure to restart your server when you modify this file.

Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'uswds-1.3.1')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'uswds-1.3.1', 'css')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'uswds-1.3.1', 'fonts')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'uswds-1.3.1', 'img')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'uswds-1.3.1', 'js')

Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'style_guide', 'stylesheets', 'uswds-0.14.0', 'img')

Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'themes', 'quill')

# AC 10/10/2018 - commenting out the following line as part of the asset pipline fix
# Rails.application.config.assets.precompile += %w( uswds.css )
Rails.application.config.assets.precompile += %w( refill/tabs.js )
Rails.application.config.assets.precompile += %w(
'fonts/merriweather-bold-webfont.eot'
'fonts/merriweather-bold-webfont.ttf'
'fonts/merriweather-bold-webfont.woff'
'fonts/merriweather-bold-webfont.woff2'
'fonts/merriweather-italic-webfont.eot'
'fonts/merriweather-italic-webfont.ttf'
'fonts/merriweather-italic-webfont.woff'
'fonts/merriweather-italic-webfont.woff2'
'fonts/merriweather-light-webfont.eot'
'fonts/merriweather-light-webfont.ttf'
'fonts/merriweather-light-webfont.woff'
'fonts/merriweather-light-webfont.woff2'
'fonts/merriweather-regular-webfont.eot'
'fonts/merriweather-regular-webfont.ttf'
'fonts/merriweather-regular-webfont.woff'
'fonts/merriweather-regular-webfont.woff2'
'fonts/sourcesanspro-bold-webfont.eot'
'fonts/sourcesanspro-bold-webfont.ttf'
'fonts/sourcesanspro-bold-webfont.woff'
'fonts/sourcesanspro-bold-webfont.woff2'
'fonts/sourcesanspro-italic-webfont.eot'
'fonts/sourcesanspro-italic-webfont.ttf'
'fonts/sourcesanspro-italic-webfont.woff'
'fonts/sourcesanspro-italic-webfont.woff2'
'fonts/sourcesanspro-light-webfont.eot'
'fonts/sourcesanspro-light-webfont.ttf'
'fonts/sourcesanspro-light-webfont.woff'
'fonts/sourcesanspro-light-webfont.woff2'
'fonts/sourcesanspro-regular-webfont.eot'
'fonts/sourcesanspro-regular-webfont.ttf'
'fonts/sourcesanspro-regular-webfont.woff'
'fonts/sourcesanspro-regular-webfont.woff2'
)

Rails.application.config.assets.precompile += %w(plus.svg)
Rails.application.config.assets.precompile += %w(sba-c-sprite.svg)
Rails.application.config.assets.precompile += %w(angle-arrow-down-primary.svg)

Rails.application.config.assets.precompile += %w( resque_web/lifebuoy.png )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/gal_del.png )

Rails.application.config.assets.precompile += %w( pdfjs/pdf.worker.js )
Rails.application.config.assets.precompile += %w( 
messages/message_links.js
messages/new_message.js 
messages/new_conversation.js
"quill.core.css"
"quill.min.js"
"quill.min.js.map"
)
