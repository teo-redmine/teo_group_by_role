require 'redmine'

# Se incluye el codigo del plugin al controlador de users
require 'group_by_role_users_patch'

ActionDispatch::Callbacks.to_prepare do
	UsersController.send(:include, TeoGroupByRole)
end

Redmine::Plugin.register :teo_group_by_role do
  name 'Teo Group By Role plugin'
  author 'Junta de Andalucía. Juan Antonio Blanco Robles.'
  description 'Este plugin modifica la vista de usuario agrupando por roles los proyectos de los que es miembro'
  version '1.0.0'
  url 'https://github.com/teo-redmine/teo_group_by_role.git'
  author_url 'http://www.juntadeandalucia.es'
end
