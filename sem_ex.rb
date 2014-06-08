require_relative 'exam'

class Semex < Exam
	@@list =		'ExamList.rb'
	@@dir = 		'txt'
	@@main = 		open('tmpl/SE_main.tex') { |f| f.read }
	@@tex_cmd =	'\ExamCard'
	
	attr_reader :course, :spec, :teacher, :zav

	def initialize(data)
		super
		@output = "output/Semester/#{@spec} #{@course}.tex"
	end


	def prepare(subl: true, latex: false)
		open(@output, 'w') do |file|
			file.write @@main % {
				renews: 	@renews,
				teacher: 	@teacher,
				zav: 			@zav,
				cards: 		texify_cards(@@tex_cmd)
			}
		end
		`subl '#{@output}'` if subl
		tex_cmd = "pdflatex -output-directory output/Semester '#{@output}'"
		if latex
			system tex_cmd
			system tex_cmd
		end
	end


	def add_tasks_from_file
		super @@dir
	end


	class << self
		def collect
			super @@list
		end
	end

end

Semex.collect do |e|
	if e.course =~ /Немец/
		# do something
	end
end