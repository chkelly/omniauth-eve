require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Eve < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "eve"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {:site => "https://login.eveonline.com"}

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['CharacterOwnerHash'] }

      info do
	{
          character_name: raw_info['CharacterName'],
          character_id: raw_info['CharacterID'],
          expires_on: raw_info['ExpiresOn'],
          scopes: raw_info['Scopes'],
          token_type: raw_info['TokenType'],
          character_owner_hash: raw_info['CharacterOwnerHash']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/oauth/verify').parsed
      end
    end
  end
end
