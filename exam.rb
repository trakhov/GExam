
class Exam

	def initialize(data)
		@renews = ''
		data.each do |key, value|
			instance_variable_set "@#{key}", value
			unless [:teacher, :zav].include? key
				@renews += "\\renewcommand{\\#{key.to_s}}{#{value}}\n"
			end
		end
	end


	def add_tasks_from_file(dir)
		# если две и более группы, берем первую
		spec = @spec.split(', ')[0]
		open(File.join dir, spec, @course + '.rb') do |file|
			@cards = eval file.read
		end
		self
	end


	def texify_cards(tex_cmd)
		@cards.map do |card|
			questions = card.join "\n\t;;\n\t"
			"\n#{tex_cmd} {\n\t#{questions}\n}\n"
		end.join "\n"
	end


	class << self

		def collect(list)
			open(list) { |f| eval f.read }.map do |hash|
				exam = new(hash)
				exam.add_tasks_from_file
				yield exam if block_given?
				exam
			end
		end

	end

end