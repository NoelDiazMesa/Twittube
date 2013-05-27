module UsuariosHelper

   def gravatar_for(usuarios, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(usuario.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: usuario.username, class: "gravatar")
  end
end
