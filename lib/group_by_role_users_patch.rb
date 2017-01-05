require_dependency 'users_controller'

module TeoGroupByRole
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			# Con esto sobreescribimos el metodo show del controlador de users
			alias_method_chain :show, :groupbyrole
		end
	end

	module InstanceMethods
		def show_with_groupbyrole
			unless @user.visible?
		      render_404
		      return
		    end

		    # show projects based on current user visibility
		    @memberships = @user.memberships.where(Project.visible_condition(User.current)).to_a

			# INICIO de parcheo
			@mapa = Hash.new

			@roles = Role.givable.sorted.to_a

			unless @roles == nil or @roles.empty?
				# Se rellena un mapa en el que la key es el nombre del rol
				# y el value es la lista de proyectos de los que es miembro con ese rol
				@roles.each do |role|
					unless @memberships == nil or @memberships.empty?
						membershipArr = Array.new

				    	@memberships.each do |membership|
				    		unless membership.roles == nil or membership.roles.empty?
				    			membership.roles.each do |memberrol|
					    			if memberrol.name == role.name
										membershipArr << membership

					    				@mapa[role.name] = membershipArr
									end
					    		end
				    		end
				    	end
					end
				end
			end
			# FIN de parcheo

		    respond_to do |format|
		      format.html {
		        events = Redmine::Activity::Fetcher.new(User.current, :author => @user).events(nil, nil, :limit => 10)
		        @events_by_day = events.group_by(&:event_date)
		        render :layout => 'base'
		      }
		      format.api
		    end
		end
	end
end

UsersController.send(:include, TeoGroupByRole::InstanceMethods)