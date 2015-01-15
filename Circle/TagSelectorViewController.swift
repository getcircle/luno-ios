//
//  TagSelectorViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

let reuseIdentifier = "Cell"

class TagSelectorViewController: UIViewController,
UITextFieldDelegate,
SearchHeaderViewDelegate {

    enum Themes {
        case Onboarding
        case Regular
    }
    
    struct TagsHolder {
        static let tags = [
            "python", "mysql", "investing", "french", "ios", "swift", "business development", "private equity", "personal finance", "C", "C++", "product", "design",
            "mobile applications", "photoshop", "product marketing", "spanish", "human resources", "management", "startups", "productivity", "customer experience", "communication", "c#", "postgres", "android",
            "hadoop", "kafka", "big data", "mac os x", "API", "hiring", "recruiting", "objective-C", "java", "visual studio", "social media", "php", "html",
            "javaScript", "html5", "css", "mongodb", "advertising", "heroku", "AWS", "fundraising", "ruby on rails", "coffeeScript", "bash scripting", "ops", "software development",
            "ActionScript","C","C#","C++","Clojure","CoffeeScript","Common Lisp","CSS","Diff","Emacs Lisp","Erlang","Haskell","HTML","Java","JavaScript","Lua","Objective-C",
            "Perl","PHP","Python","Ruby","Scala","Scheme","Shell","SQL","ABAP","Ada","Agda","AGS Script","Alloy","Ant Build System","ANTLR","ApacheConf","Apex","APL","AppleScript","Arc","Arduino","AsciiDoc","ASP","AspectJ","Assembly","ATS","Augeas","AutoHotkey","AutoIt","Awk","Batchfile","Befunge","Bison","BitBake","BlitzBasic","BlitzMax","Bluespec","Boo","Brainfuck","Brightscript","Bro","C-ObjDump","C2hs Haskell","Cap'n Proto","Ceylon","Chapel","ChucK","Cirru","Clean","CLIPS","CMake","COBOL","ColdFusion","ColdFusion CFC","Component Pascal","Cool","Coq","Cpp-ObjDump","Creole","Crystal","Cucumber","Cuda","Cycript","Cython","D","D-ObjDump","Darcs Patch","Dart","DM","Dockerfile","Dogescript","Dylan","E","Eagle","eC","Ecere Projects","ECL","edn","Eiffel","Elixir","Elm","EmberScript","F#","Factor","Fancy","Fantom","fish","FLUX","Forth","FORTRAN","Frege","G-code","Game Maker Language","GAMS","GAP","GAS","GDScript","Genshi","Gentoo Ebuild","Gentoo Eclass","Gettext Catalog","GLSL","Glyph","Gnuplot","Go","Golo","Gosu","Grace","Gradle","Grammatical Framework","Graph Modeling Language","Graphviz (DOT)","Groff","Groovy","Groovy Server Pages","Hack","Haml","Handlebars","Harbour","Haxe","HTML+Django","HTML+ERB","HTML+PHP","HTTP","Hy","IDL","Idris","IGOR Pro","Inform 7","INI","Inno Setup","Io","Ioke","IRC log","Isabelle","J","Jade","Jasmin","Java Server Pages","JSON","JSON5","JSONiq","JSONLD","Julia","Kit","Kotlin","KRL","LabVIEW","Lasso","Latte","Less","LFE","LilyPond","Liquid","Literate Agda","Literate CoffeeScript","Literate Haskell","LiveScript","LLVM","Logos","Logtalk","LOLCODE","LookML","LoomScript","LSL","M","Makefile","Mako","Markdown","Mask","Mathematica","Matlab","Maven POM","Max","MediaWiki","Mercury","MiniD","Mirah","Monkey","Moocode","MoonScript","MTML","mupad","Myghty","Nemerle","nesC","NetLogo","Nginx","Nimrod","Ninja","Nit","Nix","NSIS","Nu","NumPy","ObjDump","Objective-C++","Objective-J","OCaml","Omgrofl","ooc","Opa","Opal","OpenCL","OpenEdge ABL","OpenSCAD","Org","Ox","Oxygene","Oz","Pan","Papyrus","Parrot","Parrot Assembly","Parrot Internal Representation","Pascal","PAWN","Perl6","PigLatin","Pike","Pod","PogoScript","PostScript","PowerShell","Processing","Prolog","Propeller Spin","Protocol Buffer","Public Key","Puppet","Pure Data","PureBasic","PureScript","Python traceback","QMake","QML","R","Racket","Ragel in Ruby Host","RAML","Raw token data","RDoc","REALbasic","Rebol","Red","Redcode","reStructuredText","RHTML","RMarkdown","RobotFramework","Rouge","Rust","Sage","SAS","Sass","Scaml","Scilab","SCSS","Self","ShellSession","Shen","Slash","Slim","Smalltalk","Smarty","SourcePawn","SQF","Squirrel","Standard ML","Stata","STON","Stylus","SuperCollider","Swift","SystemVerilog","Tcl","Tcsh","Tea","TeX","Text","Textile","Thrift","TOML","Turing","Twig","TXL","TypeScript","Unified Parallel C","UnrealScript","Vala","VCL","Verilog","VHDL","VimL","Visual Basic","Volt","WebIDL","wisp","xBase","XC","XML","Xojo","XProc","XQuery","XS","XSLT","Xtend","YAML","Zephir","Zimpl",
        ]

        static var tagObjects = Array<ProfileService.Containers.Tag>()
    }
    
    @IBOutlet weak private(set) var addTagButton: UIButton!
    @IBOutlet weak private(set) var addTagButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var bottomGradientView: UIView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var doneButton: UIButton!
    @IBOutlet weak private(set) var searchControllerParentView: UIView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleTextLabel: UILabel!
    @IBOutlet weak private(set) var topGradientView: UIView!
    
    var theme: Themes = .Regular
    
    private var addTagButtonInitialHeight: CGFloat = 0.0
    private var animatedCell = [NSIndexPath: Bool]()
    private var bottomLayer: CAGradientLayer!
    private var cachedItemSizes =  [String: CGSize]()
    private var filteredTags = Array<ProfileService.Containers.Tag>()
    private var prototypeCell: TagCollectionViewCell!
    private var searchHeaderView: SearchHeaderView!
    private var selectedTags = NSMutableSet()
    private var topLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TEMP LOGIC TO CREATE TAG OBJECTS
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            println("Started")
            let startTime = NSDate()
            var tagObjects = Array<ProfileService.Containers.Tag>()
            for tag in TagsHolder.tags {
                var tagObject = ProfileService.Containers.Tag.builder()
                tagObject.id = tag
                tagObject.name = tag
                tagObjects.append(tagObject.build())
            }
            
            TagsHolder.tagObjects = tagObjects
            self.filteredTags = TagsHolder.tagObjects
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
            let endTime = NSDate()
            println("Execution Time = \(endTime.timeIntervalSinceDate(startTime))")
        })
            
        // Configurations
        setStatusBarHidden(true)
        configureView()
        configureSearchHeaderView()
        configurePrototypeCell()
        configureCollectionView()
        configureGradients()
        configureAddTagButton()
        configureViewByTheme()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        filteredTags = TagsHolder.tagObjects
        collectionView.reloadData()
    }
    
    // MARK: - Configuration

    private func configureView() {
        edgesForExtendedLayout = .Top
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
    }
    
    private func configureCollectionView() {
        collectionView.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.allowsMultipleSelection = true
        
    }

    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.clearButtonMode = .Always
            searchHeaderView.searchTextField.returnKeyType = .Done
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.placeholder = NSLocalizedString("Filter tags", comment: "Placeholder text for filter tags input box")
            searchHeaderView.searchTextField.addTarget(self, action: "filter", forControlEvents: .EditingChanged)
            searchControllerParentView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            switch theme {
            case .Onboarding:
                searchHeaderView.containerBackgroundColor = UIColor.appTintColor()
                searchHeaderView.searchFieldBackgroundColor = UIColor.appTintColor()
                searchHeaderView.searchFieldTintColor = UIColor.whiteColor()
                searchHeaderView.searchFieldTextColor = UIColor.whiteColor()
                searchHeaderView.cancelButton.tintColor = UIColor.whiteColor()
                searchHeaderView.searchTextField.keyboardAppearance = .Dark
                searchHeaderView.updateView()
                
            case .Regular:
                break
            }
        }
    }
    
    private func configureGradients() {
        let startColor = UIColor.appTintColor().CGColor
        let endColor = UIColor.appTintColor().colorWithAlphaComponent(0.0).CGColor
        
        // Top
        topLayer = CALayer.gradientLayerWithFrame(
            topGrientLayerFrame(),
            startColor: startColor,
            endColor: endColor
        )
        topGradientView.layer.addSublayer(topLayer)
        
        // Bottom
        bottomLayer = CALayer.gradientLayerWithFrame(
            bottomGradientLayerFrame(),
            startColor: endColor,
            endColor: startColor
        )
        bottomGradientView.layer.addSublayer(bottomLayer)
    }
    
    private func configureAddTagButton() {
        addTagButtonInitialHeight = addTagButtonHeightConstraint.constant
        addTagButton.setImage(
            addTagButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )

        hideAddTagButton()
    }
    
    private func configureViewByTheme() {
        switch theme {
        case .Onboarding:
            view.backgroundColor = UIColor.appTintColor()
            collectionView.backgroundColor = UIColor.appTintColor()
            searchControllerParentView.backgroundColor = UIColor.appTintColor()
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.backgroundColor = UIColor.appTintColor()
            titleTextLabel.textColor = UIColor.whiteColor()
            titleTextLabel.backgroundColor = UIColor.appTintColor()
            doneButton.backgroundColor = UIColor.appTintColor()
            addTagButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
            addTagButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
            addTagButton.tintColor = UIColor.appTintColor()

        case .Regular:
            break
        }
    }

    private func configureCellByTheme(cell: TagCollectionViewCell) {
        switch theme {
        case .Onboarding:
            cell.backgroundColor = UIColor.appTintColor()
            cell.defaultTextColor = UIColor.whiteColor()
            cell.defaultBackgroundColor = UIColor.appTintColor()
            cell.defaultBorderColor = UIColor.whiteColor()
            
            cell.highlightedTextColor = UIColor.appTintColor()
            cell.highlightedBackgroundColor = UIColor.whiteColor()
            cell.highlightedBorderColor = UIColor.appTintColor()

        case .Regular:
            break
        }
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTags.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagCollectionViewCell
    
        // Configure the cell
        cell.tagLabel.text = filteredTags[indexPath.row].name.capitalizedString
        configureCellByTheme(cell)
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }

        // Manage Selection
        if cell.selected {
            cell.selectCell(false)
        }
        else if selectedTags.containsObject(filteredTags[indexPath.row].name) {
            cell.selectCell(false)
            cell.selected = true
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: nil)
        }
        else {
            cell.unHighlightCell(false)
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.highlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.selectCell(true)
        selectedTags.addObject(filteredTags[indexPath.row].name)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
        selectedTags.removeObject(filteredTags[indexPath.row])
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tagText = filteredTags[indexPath.row].name.capitalizedString
        if cachedItemSizes[tagText] == nil {
            prototypeCell.tagLabel.text = tagText
            prototypeCell.setNeedsLayout()
            prototypeCell.layoutIfNeeded()
            cachedItemSizes[tagText] = prototypeCell.intrinsicContentSize()
        }
        
        return cachedItemSizes[tagText]!
    }

    // MARK: - IBActions
    
    @IBAction func close(sender: AnyObject!) {
        dismissSearchField()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTagButtedTapped(sender: AnyObject!) {
        var tagName = searchHeaderView.searchTextField.text
        tagName = tagName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if tagName != "" {
            
            var tagBuilderObject = ProfileService.Containers.Tag.builder()
            tagBuilderObject.name = tagName
            
            // Add to source
            TagsHolder.tagObjects.append(tagBuilderObject.build())
            
            // Add to selected
            selectedTags.addObject(tagName)
            
            // Call filter again
            filter()
            
            // Hide the button
            hideAddTagButton()
        }
    }
    
    // MARK: - SearchHeaderViewDelegate

    func didCancel(sender: UIView) {
        collectionView.reloadData()
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func filter() {
        let searchString = searchHeaderView.searchTextField.text
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let trimmedString = searchString.stringByTrimmingCharactersInSet(whitespaceCharacterSet).lowercaseString
        if trimmedString == "" {
            filteredTags = TagsHolder.tagObjects
            hideAddTagButton()
        }
        else {
            // We need to filter each time from the full set to handle backspace correctly.
            // We used filteredTags to make things specific but that only make sense when adding characters.
            filteredTags = TagsHolder.tagObjects.filter({ $0.name.lowercaseString.hasPrefix(trimmedString) })
            addTagButton.setTitle(
                NSString(format: NSLocalizedString("Add tag \"%@\"", comment: "Button title used when adding a tag with name %@"), trimmedString),
                forState: .Normal
            )
            showAddTagButton()
        }
        
        if filteredTags.count != TagsHolder.tags.count || trimmedString == "" {
            collectionView.reloadData()
        }
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldClear(textField: UITextField) -> Bool {
        collectionView.reloadData()
        
        // If the user hits the clear button when there is no content, the intention most likely
        // is to dismiss the view
        if textField.text == "" {
            dismissSearchField()
        }
        
        hideAddTagButton()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        topGradientView.hidden = true
        bottomGradientView.hidden = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        topGradientView.hidden = false
        bottomGradientView.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissSearchField()
        collectionView.reloadData()
        hideAddTagButton()
        return true
    }
    
    // MARK: - Helpers
    
    private func topGrientLayerFrame() -> CGRect {
        return CGRectMake(10.0, 0.0, topGradientView.frameWidth - 20.0, 30.0)
    }
    
    private func bottomGradientLayerFrame() -> CGRect {
        return CGRectMake(10.0, 0.0, bottomGradientView.frameWidth - 20.0, 60.0)
    }
    
    private func dismissSearchField() {
        searchHeaderView.searchTextField.text = ""
        searchHeaderView.searchTextField.resignFirstResponder()
    }
    
    private func showAddTagButton() {
        addTagButtonHeightConstraint.constant = addTagButtonInitialHeight
        addTagButton.updateConstraints()
        addTagButton.layoutIfNeeded()
    }
    
    private func hideAddTagButton() {
        addTagButtonHeightConstraint.constant = 0.0
        addTagButton.updateConstraints()
        addTagButton.layoutIfNeeded()
    }
}
