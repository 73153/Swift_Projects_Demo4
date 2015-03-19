//
//  SESwipeableTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

@objc protocol SESwipeableTableViewCellDelegate: NSObjectProtocol {
    
    /**
     *  Called when UIPanGestureRecognizer used for swipe gesture emits UIGestureRecognizerStateBegin to it's delegate.
     *
     *  @param cell cell which started moving content
     */
    @optional func swipeableCellWillStartMovingContent(cell: SESwipeableTableViewCell!)
    
    /**
     *  Called after topmost cell view is moved to the left to display bottom view (ie. delete button);
     *
     *  @param cell cell which did move it's top view
     */
    func cellDidOpen(cell: SESwipeableTableViewCell!)
    
    /**
     *  Called after topmost cell view is moved to the right to hide bottom view (ie. delete button);
     *
     *  @param cell cell which did move it's top view
     */
    func cellDidClose(cell: SESwipeableTableViewCell!)
    
}

class SESwipeableTableViewCell: UITableViewCell {
    
    /**
     *  Delegate, this object will be notified about cell swipe actions.
     */
    weak var delegate: SESwipeableTableViewCellDelegate?
    
    /**
     *  Propert that enables or disables swipe gesture
     */
    var swipeEnabled = true
    
    /**
     *  Width of the cell bottom view (ie. delete button), top view (content) will be moved left on swipe gesture for this value.
     */
    var rightBottomCellViewWidth: Float!
    
    /**
     *  Bottom view of the cell (ie. delete button).
     */
    @IBOutlet var bottomCellView: UIView
    
    /**
     *  Top view of the cell (content that will be swiped).
     */
    @IBOutlet var topCellView: UIView
    
    /**
     *  Left constraint of the topCellView
     */
    @IBOutlet var topCellViewLeftConstraint: NSLayoutConstraint
    
    /**
     *  Right constraint of the topCellView
     */
    @IBOutlet var topCellViewRightConstraint: NSLayoutConstraint
    
    /**
     *  Width constraint of the bottomCellView
     */
    @IBOutlet var bottomCellViewWidthConstraint: NSLayoutConstraint
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var panStartPoint: CGPoint!
    var startingRightLayoutConstraintConstant: Float!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func awakeFromNib() {
        // Initialization code
        self.setupView()
    }
    
    /**
     *  Reset constraints value on cell reuse (close the cell)
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetConstraintContstantsToZero(false, notifyDelegateDidClose: false)
    }
    
    /**
     *  Setup cell apperance, pan gesture recognizer, and rewrite width of bottom view to rightBottomCellViewWidth property
     */
    func setupView() {
        self.accessoryType = .None
        self.selectionStyle = .None
        self.editingAccessoryType = .None
        
        self.rightBottomCellViewWidth = self.bottomCellViewWidthConstraint.constant;
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panThisCell:");
        self.panGestureRecognizer.delegate = self
        self.topCellView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    //#pragma mark - UIGestureRecognizerDelegate
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //#pragma mark - actions
    /**
     *  Move topCellView (content) depending on gesture direction and current position of the view.
     *  This method is fired by panGestureRecognizer attached to topCellView
     *
     *  @param panGestureRecognizer UIPanGestureRecognizer object that send a message
     */
    func panThisCell(panGestureRecognizer: UIPanGestureRecognizer) {
        if !self.swipeEnabled {
            return;
        }
        
        switch panGestureRecognizer.state {
        case .Began:
            self.panStartPoint = panGestureRecognizer.translationInView(self.topCellView)
            self.startingRightLayoutConstraintConstant = self.topCellViewRightConstraint.constant
        case .Changed:
            var currentPoint = panGestureRecognizer.translationInView(self.topCellView)
            var deltaX = currentPoint.x - self.panStartPoint.x
            var panningLeft = false
            if currentPoint.x < self.panStartPoint.x {
                panningLeft = true
            }
            
            if self.startingRightLayoutConstraintConstant == 0 {
                //The cell was closed and is now opening
                if !panningLeft {
                    var constant = max(-deltaX, 0)
                    if constant == 0 {
                        self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: false)
                    } else {
                        self.topCellViewRightConstraint.constant = constant
                    }
                } else {
                    if self.delegate? && self.delegate?.swipeableCellWillStartMovingContent?(self) {
                        self.delegate!.swipeableCellWillStartMovingContent!(self)
                    }
                    
                    var constant = min(-deltaX, self.rightBottomCellViewWidth)
                    if constant == self.rightBottomCellViewWidth {
                        self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: false)
                    } else {
                        self.topCellViewRightConstraint.constant = constant
                    }
                }
            } else {
                //The cell was at least partially open.
                var adjustment = self.startingRightLayoutConstraintConstant - deltaX
                if !panningLeft {
                    var constant = max(adjustment, 0)
                    if constant == 0 {
                        self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: false)
                    } else {
                        self.topCellViewRightConstraint.constant = constant
                    }
                } else {
                    var constant = min(adjustment, self.rightBottomCellViewWidth)
                    if constant == self.rightBottomCellViewWidth {
                        self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: false)
                    } else {
                        self.topCellViewRightConstraint.constant = constant
                    }
                }
            }
            self.topCellViewLeftConstraint.constant = -self.topCellViewRightConstraint.constant
        case .Ended:
            if self.startingRightLayoutConstraintConstant == 0 { //1
                //Cell was opening
                var halfOfButtonOne = self.rightBottomCellViewWidth / 2 //2
                if self.topCellViewRightConstraint.constant >= halfOfButtonOne { //3
                    //Open all the way
                    self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
                } else {
                    //Re-close
                    self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: true)
                }
            } else {
                //Cell was closing
                var buttonOnePlusHalfOfButton2 = self.rightBottomCellViewWidth * 0.75 //4
                if self.topCellViewRightConstraint.constant >= buttonOnePlusHalfOfButton2 { //5
                    //Re-open all the way
                    self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
                } else {
                    //Close
                    self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: true)
                }
            }
        case .Cancelled:
            if self.startingRightLayoutConstraintConstant == 0 {
                //Cell was closed - reset everything to 0
                self.resetConstraintContstantsToZero(true, notifyDelegateDidClose: true)
            } else {
                //Cell was open - reset to the open state
                self.setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
            }
        default:
            break;
        }
    }
    
    //#pragma mark - public tasks
    /**
     *  Move topCellView left (open)
     *
     *  @param animated BOOL should it be animated
     */
    func openCellAnimated(animated: Bool) {
        self.setConstraintsToShowAllButtons(animated, notifyDelegateDidOpen: false)
    }
    
    /**
     *  Move topCellView right (close)
     *
     *  @param animated BOOL should it be animated
     */
    func closeCellAnimated(animated: Bool) {
        self.resetConstraintContstantsToZero(animated, notifyDelegateDidClose: false)
    }
    
    //#pragma mark - tasks
    /**
     *  Performs constraint transformation needed to "close the cell" and hide bottomCellView
     *
     *  @param animated       should the transfrom be animated
     *  @param notifyDelegate should delegate be notified about this transformation
     */
    func resetConstraintContstantsToZero(animated: Bool, notifyDelegateDidClose notifyDelegate: Bool) {
        if notifyDelegate {
            self.delegate?.cellDidClose(self)
        }
        
        if self.startingRightLayoutConstraintConstant == 0 && self.topCellViewRightConstraint.constant == 0 {
            //Already all the way closed, no bounce necessary
            return
        }
        
        self.updateConstraintsIfNeeded(animated) {
            finished in
            self.topCellViewRightConstraint.constant = 0
            self.topCellViewLeftConstraint.constant = 0
            
            self.updateConstraintsIfNeeded(animated) {
                finished in
                self.startingRightLayoutConstraintConstant = self.topCellViewRightConstraint.constant
            }
        }
    }
    
    /**
     *  Performs constraint transformation needed to "open the cell" and show bottomCellView
     *
     *  @param animated       should the transfrom be animated
     *  @param notifyDelegate should delegate be notified about this transformation
     */
    func setConstraintsToShowAllButtons(animated: Bool, notifyDelegateDidOpen notifyDelegate: Bool) {
        if notifyDelegate {
            self.delegate?.cellDidOpen(self)
        }
        
        if self.startingRightLayoutConstraintConstant == self.rightBottomCellViewWidth && self.topCellViewRightConstraint.constant == self.rightBottomCellViewWidth {
            return
        }
        
        self.updateConstraintsIfNeeded(animated) {
            finished in
            self.topCellViewLeftConstraint.constant = -self.rightBottomCellViewWidth
            self.topCellViewRightConstraint.constant = self.rightBottomCellViewWidth
            
            self.updateConstraintsIfNeeded(animated) {
                finished in
                self.startingRightLayoutConstraintConstant = self.topCellViewRightConstraint.constant
            }
        }
    }
    
    /**
     *  Commits the change of the constraint values
     *
     *  @param animated   should the change be animated
     *  @param completion completion handler
     */
    func updateConstraintsIfNeeded(animated: Bool, completion: (finished: Bool) -> ()) {
        var duration: Double = 0.0
        if animated {
            duration = 0.1
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: completion)
    }
}
