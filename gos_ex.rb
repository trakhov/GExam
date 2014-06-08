require_relative 'exam'

class GExam < Exam
	@@list = 		'GExamList.rb'
	@@dir = 		'txt/GE'
	@@main = 		open('tmpl/GE_main.tex') { |f| f.read }
	@@tex_cmd = 		'\GExamCard'	


	def initialize(data)
		super
		@course = 'ГОСЭКЗАМЕН'
		@course += @type if @type
		@output =	"output/GOS/#{spec} "
	end


end
