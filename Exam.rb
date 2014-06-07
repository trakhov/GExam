

class Exam

	def initialize(data)
		data.each do |k, v|
			instance_variable_set "@#{k}", v
		end
		@renews = data.map do |k, v|
			unless [:teacher, :zav].include? k
				"\\renewcommand{\\#{k.to_s}}{#{v}}"
			end
		end.compact.join("\n")
	end
	

	def add_tasks_from_file(dir)
		# если две и более группы, берем первую
		spec = @spec.split(', ')[0]
		open(File.join dir, spec, @course + '.rb') do |file|
			@tasks = eval file.read
		end
	end


	def make_cards(cmd)
		cards = ''
		@tasks.each do |card|
			questions = card.join "\n\t;;\n\t"
			cards += "\n#{cmd} {\n\t#{questions}\n}\n"
		end
		cards
	end


	def get_out_name(dir)
		filename = "#{@spec} #{@course}.tex"
		File.join 'output', dir, filename
	end


	class << self
		
		def collect(list)
			out = []
			open(list) { |f| eval f.read }.each do |hash|
				exam = self.new hash
				exam.add_tasks_from_file
				out << exam
			end
			out
		end

	end

end



class SemEx < Exam
	@@list = 		'ExamList.rb'
	@@dir = 		'txt'
	@@main = 		open('tmpl/SE_main.tex') { |f| f.read }
	@@cmd = 		'\ExamCard'
	@@out_dir =	'Semester' 



	def prepare(subl: true)
		cards = make_cards @@cmd
		out = get_out_name @@out_dir

		open(out, 'w') do |file|
			file.write @@main % {
				renews: @renews,
				teacher: @teacher,
				zav: @zav,
				cards: cards
			}
		end

		`subl '#{out}'` if subl
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


# todo:
# class GExam < Exam	
# 	@@list = 		'GExamList.rb'
# 	@@dir = 		'txt/GE'
# 	@@main = 		open('tmpl/GE_main.tex') { |f| f.read }
# 	@@cmd = 		'\GExamCard'
# 	@@out_dir =	'Госэкзамены' 


# 	def initialize(data)
# 		super 
# 		@course = 'ГОСЭКЗАМЕН'
# 	end

	
# end



SemEx.collect.each { |exam| exam.prepare }




