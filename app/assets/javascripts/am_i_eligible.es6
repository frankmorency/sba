class AmIEligible {
    constructor(data) {
        this.eligibility = new Map()
        this.questions = []
        this.certifications = ['wosb', 'edwosb', 'eighta', 'hubzone']
        this.reasons = new Map()
        this.answers = new Map()
        this.current = null
        this.requirements = new Map()
        this.messages = new Map()
        this.emailMessages = new Map()
        this.expectedAnswers = new Map()
        this.edwosb_naics_codes = data.edwosb_naics_codes
        this.wosb_naics_codes = data.wosb_naics_codes
        this.specialMessages = new Map()
        this.specialMessageQuestions = []
        this.current_reason = ''
        this.current_reason_email = ''

        for (let c of this.certifications) {
            this.requirements.set(c, [])
            this.resetMessages(c)
        }

        for (let question of data.questions) {
            this.questions.push(question.name)
            this.answers.set(question.name, null)
            if (question.special_message == true) {
                this.specialMessages.set(question.name, true)
                this.specialMessageQuestions.push(question.name)
            }
            this.expectedAnswers.set(question.name, question.expected)
            this.reasons.set(question.name, question.reason)

            for (let cert of question.requirements) {
                var reqs = this.requirements.get(cert)
                reqs.push(question.name)
                this.requirements.set(cert, reqs)
            }
        }
    }

    resetMessages(c) {
        if (c == 'eighta') {
            this.messages.set(c, [`<b>Based on the information you provided, you may not be eligible for the 8(a) BD Program:</b>`])
            this.emailMessages.set(c, [``])
        } else if (c == 'hubzone') {
            this.messages.set(c, [`<b>Based on the information you provided, you may not be eligible for the HUBZone Program:</b>`])
            this.emailMessages.set(c, [``])
        } else {
            this.messages.set(c, [`<b>Based on the information you provided, you may not be eligible for the ${c.toUpperCase()} Program:</b>`])
            this.emailMessages.set(c, [``])
        }
    }

    failedOut() {
        for (let c of this.certifications) {
            if (this.eligibility.get(c) != false) {
                return false
            }
        }

        return true
    }

    currentQuestion() {
        return this.questions[this.current]
    }

    nextQuestion() {
        return this.questions[this.current + 1]
    }

    lastQuestion() {
        return this.questions[this.questions.length - 1] == this.currentQuestion()
    }

    showNextQuestion() {
        $(`.question#${this.nextQuestion()} .q`).show("fold", 500)
    }

    hideEligibility() {
        $('#special').hide()
        $('#results').hide()
        $('#success').hide()
        $('#failure').hide()
        $("#not_eligible").hide()
        $(".eligible").hide()
    }

    showEligibility() {
        for (let q of this.specialMessageQuestions) {
            if (this.answers.get(q) == false) {
                $('#special .message').html(this.reasons.get(q))
                $('#special').show()
                $('<input>').attr({type: 'hidden', id: `${q}`, name: 'special_message', value: `${this.reasons.get(q)}`}).appendTo('#email_results');
                $('#email_results').show()
                return
            }
        }

        $('#results').show()

        for (let c of this.certifications) {
            if (this.eligibility.get(c) == false) {

                $(`#${c} .not_eligible`).html(this.messages.get(c).join('<br>')).show()
                $(`#${c} .eligible`).hide()
                $(`#${c}`).removeClass('success-box')
                $(`#${c}`).addClass('failure-box')

                if ($(`#${c}`).parent().attr('id') == 'success') {
                    $('#failure').append($(`#${c}`).detach())
                }

                var massage = this.emailMessages.get(c).join(',');
                var hadi = `${c}` + '_msg';

                $('<input>').attr({type: 'hidden', id: `${c}`, name: 'eligibility_value', value: 'false'}).appendTo('#email_results');
                $('<input>').attr({type: 'hidden', id: hadi, name: 'message_email', value: massage }).appendTo('#email_results');

                $('#failure').show()
            } else {
                $(`#${c} .eligible`).show()
                $(`#${c} .not_eligible`).hide()
                $(`#${c}`).addClass('success-box')
                $(`#${c}`).removeClass('failure-box')

                if ($(`#${c}`).parent().attr('id') == 'failure') {
                    $('#success').append($(`#${c}`).detach())
                }

                $('<input>').attr({type: 'hidden', id: `${c}`, name: 'eligibility_value', value: 'true'}).appendTo('#email_results');

                $('#success').show()
            }

            $(`#${c}`).show()
        }

        $('#email_results').show()
    }

    debug() {
        console.log(this.eligibility)
        console.log(this.answers)
        console.log(this.messages)
        console.log(this.specialMessages)
        console.log(this.specialMessageQuestions)
    }

    answerAndCheck(question, value, certification_type = '') {
        if (question == 'naics_button') {
            return;
        }

        this.answer(question, value, certification_type)
        this.determineAllEligibility()

        if (this.failedOut()) {
            this.showEligibility()
        } else if (this.lastQuestion()) {
            this.showEligibility()
        } else {
            this.showNextQuestion()
        }
    }

    answer(question, value, certification_type = '') {
        this.setCurrent(question)

        if (certification_type != ''){
            $(`.question#${this.currentQuestion()} .a .yes`).html('<b>Yes</b>, '+certification_type.toUpperCase()+' Federal Contract Program set-asides are available in your primary NAICS code.')
            $(`.question#${this.currentQuestion()} .a .no`).html('<b>No</b>, '+certification_type.toUpperCase()+' Federal Contract Program set-asides are not available in your primary NAICS code.')
        }

        $(`.question#${this.currentQuestion()} .q`).hide()
        $(`.question#${this.currentQuestion()} .a`).show()
        $(`.question#${this.currentQuestion()} .a .no`).show()
        $(`.question#${this.currentQuestion()} .a .yes`).show()

        if (this.expectedAnswers.get(question) != value) {
            this.current_reason = this.reasons.get(question)
            this.current_reason_email = question

            if (this.current_reason) {
                for (let c of this.requiredFor(question)) {
                    if (this.messages.get(c).indexOf(this.current_reason) == -1) {
                        var msgs = this.messages.get(c)
                        msgs.push(this.current_reason)
                        this.messages.set(c, msgs)

                        var email_msgs = this.emailMessages.get(c)
                        email_msgs.push(this.current_reason_email)
                        this.emailMessages.set(c, email_msgs)
                    }
                }
            }
        }

        if (value) {
            $(`.question#${this.currentQuestion()} .a .no`).hide()
        } else {
            $(`.question#${this.currentQuestion()} .a .yes`).hide()
        }

        this.answers.set(question, value)
    }

    setCurrent(question) {
        this.current = this.questions.indexOf(question)
    }

    requiredFor(question) {
        var certs = []

        for (let c of this.certifications) {
            if (this.requirements.get(c).indexOf(question) != -1) {
                certs.push(c)
            }
        }

        return certs
    }

    determineAllEligibility() {
        for (let c of this.certifications) {
            this.eligibility.set(c, this.determineEligibility(c))
        }
    }

    determineEligibility(cert) {
        for (let question of this.requirements.get(cert)) {
            if (this.answers.get(question) == null) {
                return null
            } else if (this.answers.get(question) != this.expectedAnswers.get(question)) {
                return false
            }
        }

        return true
    }

    changeAnswer(question) {
        this.hideEligibility()
        $(".question .q").hide()
        $(`.question#${question} .q`).show()
        $(`.question#${question} .a`).hide()
        $("#email-container").hide()
        $('#email_results').hide()
        $("input[name='eligibility_value']").remove()


        var i = this.questions.indexOf(question)

        while (i <= this.questions.length) {
            var q = this.questions[++i]

            this.answers.set(q, null)
            $(`.question#${q} .q`).hide()
            $(`.question#${q} .a`).hide()
        }

        for (let c of this.certifications) {
            $(`#${c}`).hide()
            this.resetMessages(c)
        }
    }

    start() {
        for (let question of this.questions) {
            $(`.question#${question} .a`).hide()

            if (question != this.questions[0]) {
                $(`.question#${question} .q`).hide()
            }
        }
    }
}