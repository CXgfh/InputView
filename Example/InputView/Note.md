
##配置类（对TextView）
InputTextConfig


#InputView
##图层
leftActionStackView --- textView（placeholderStackView）/voiceView --- rightActionStackView
                                
                                    AdditionView

###leftActionStackView
    leftActionViewSpacing

###placeholderStackView
    placeholderSpacing
    placeholderText
    placeholderImage
    placeholderAttributedText
    
###rightActionStackView
    rightActionViewSpacing
                   
###AdditionView(公开的)
    bindKeyBoard后添加的一个新view，用于遮挡
    
###textView
    
###voiceView(公开的)

##方法
    addAssociateView
    addExpressionView
    addVoiceView
    addAcitonView
    
            
