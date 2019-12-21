class DestroyagendaMailer < ApplicationMailer
    default from: 'from@example.com'
    def destroyagenda_mail(agenda, member)
     @agenda = agenda
     mail to: member.email, subject: 'アジェンダを削除'
   end

end
