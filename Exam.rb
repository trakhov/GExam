

class Exam

	def initialize(data)
		data.each do |k, v|
			instance_variable_set "@#{k}", v
		end
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


	def renew(opts)
		# opts = @@defaults.merge options
		opts.map do |k, v|
			"\\renewcommand{\\#{k.to_s}}{#{v}}"
		end.join("\n")
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



	def prepare(opts: {}, subl: true)
		defaults = {
			spec: @spec,
			disc: @course,
			kaf: @kaf
		}
		options = defaults.merge opts
		cards = make_cards @@cmd
		out = get_out_name @@out_dir

		open(out, 'w') do |file|
			file.write @@main % {
				renews: renew(options),
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



e = SemEx.collect[0]

e.prepare opts: {protocol: '13.12.2014'}
