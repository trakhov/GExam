

class Exam
	attr_reader :data

	def initialize(data)
		@d = data
	end


	def pr
		@d.each do |k, v|
			print "%8s: %s\n" % [k, v]
		end
	end


	class << self
		def collect
			out = []

			open(self.list) { |f| eval f.read }.each do |hash|
				exam = self.new hash
				exam.add_tasks_from_file

				out << exam
			end
			
			out
		end
	end

end



class SemEx < Exam
	@@list = 'ExamList.rb'
	@@dir = 'txt'

	def self.list
		@@list
	end

	def add_tasks_from_file
		open(File.join @@dir, @d[:spec], @d[:course] + '.rb') do |file|
			@d[:tasks] = eval file.read
		end
	end

end





sem = SemEx.collect

p sem[0]
