//
//  StoriesViewController.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 07.12.2022.
//

import MessageUI
import UIKit
import RxSwift

class StoriesViewController: UIViewController {
    
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: StoriesViewModelProtocol
    
    init(viewModel: StoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createBindings()
        createTableViewBindings()
    }
    
    private func setupUI() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = topView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topView.insertSubview(blurEffectView, at: 0)

    }
    
    private func createBindings() {
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchTextRelay)
            .disposed(by: viewModel.disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .do(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .subscribe()
            .disposed(by: viewModel.disposeBag)
                
    }
    
    private func createTableViewBindings() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "StoryTableViewCell", bundle: nil), forCellReuseIdentifier: "StoryTableViewCell")
        
        viewModel.filteredStoriesObservable.bind(to: tableView.rx.items(cellIdentifier: "StoryTableViewCell", cellType: StoryTableViewCell.self)) { index, element, cell in
            cell.configureCellWith(story: element)
        }
        .disposed(by: viewModel.disposeBag)
        
        tableView.rx.modelSelected(Story.self)
            .do(onNext: { [weak self] story in
                self?.createEmailFrom(story)
            })
            .subscribe()
            .disposed(by: viewModel.disposeBag)

    }
    
    private func createEmailFrom(_ story: Story) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(story.title)
            mail.setMessageBody(story.description, isHTML: false)
            
            present(mail, animated: true, completion: nil)
        }
    }

}

extension StoriesViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
