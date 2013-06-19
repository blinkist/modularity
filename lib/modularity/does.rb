require 'modularity/inflector'
require 'modularity/as_trait'

module Modularity
	module Does

		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def does(trait_name, *args)
				caller_path = File.dirname(caller[0].partition(":").first)
				require "#{caller_path}/#{trait_name}_trait"
				full_trait_name = "#{self.name}Traits::#{Modularity::Inflector.camelize(trait_name.to_s)}Trait"
				trait = Modularity::Inflector.constantize(full_trait_name)
				macro = trait.instance_variable_get("@trait_macro") or raise "Missing trait directive in #{trait_name}"
				class_exec(*args, &macro)
			end
		end

	end
end

Object.send :include, Modularity::Does
