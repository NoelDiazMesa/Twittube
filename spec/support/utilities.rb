def full_title(page_title)
  base_title = "Twittube"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(usuario)
  visit signin_path
  fill_in "Email",    with: usuario.email
  fill_in "Password", with: usuario.password
  click_button "Acceder"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = usuario.remember_token
end
