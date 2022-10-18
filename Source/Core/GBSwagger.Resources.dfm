object GBSwaggerResources: TGBSwaggerResources
  Height = 246
  Width = 388
  object swagger_html: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '  <head>'
      '    <meta charset="UTF-8">'
      '    <title>::SWAGGER_TITLE</title>'
      
        #9'<link rel="stylesheet" type="text/css" href="::SWAGGER_CSS/swag' +
        'ger-ui.css" >'
      '    <style>'
      ''
      '      html'
      '      {'
      '        box-sizing: border-box;'
      '        overflow: -moz-scrollbars-vertical;'
      '        overflow-y: scroll;'
      '      }'
      ''
      '      *,'
      '      *:before,'
      '      *:after'
      '      {'
      '        box-sizing: inherit;'
      '      }'
      ''
      '      body'
      '      {'
      '        margin:0;'
      '        background: #fafafa;'
      '      }'
      #9'  '
      '    </style>'
      '  </head>'
      ''
      '  <body>'
      '    <div id="swagger-ui"></div>'
      
        #9'<script src="::SWAGGER_UI_BUNDLE_JS/swagger-ui-bundle.js"> </sc' +
        'ript>'
      
        '    <script src="::SWAGGER_UI_STANDALONE/swagger-ui-standalone-p' +
        'reset.js"> </script>'
      '    '
      '    <script>'
      '    window.onload = function() {'
      '      // Begin Swagger UI call region'
      '      const ui = SwaggerUIBundle({'
      '        url: "::SWAGGER_JSON", '
      '        dom_id: '#39'#swagger-ui'#39','
      '        docExpansion: '#39'::SWAGGER_DOC_EXPANSION'#39','
      '        deepLinking: true,'
      '        presets: ['
      '          SwaggerUIBundle.presets.apis,'
      '          SwaggerUIStandalonePreset'
      '        ],'
      '        plugins: ['
      '          SwaggerUIBundle.plugins.DownloadUrl'
      '        ],'
      '        layout: "StandaloneLayout"'
      '      })'
      '      // End Swagger UI call region'
      ''
      '      window.ui = ui'
      '    }'
      '  </script>'
      '  </body>'
      '</html>')
    Left = 24
    Top = 24
  end
end
