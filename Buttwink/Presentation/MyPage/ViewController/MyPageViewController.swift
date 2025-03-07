//
//  MyPageViewController.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/26/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class MyPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 클래스"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    /// 추후 구현
    private let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configureCollectionView()
        self.bind()
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.profileView)
        self.view.addSubview(self.collectionView)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        self.profileView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
  
    private func configureCollectionView() {
        self.collectionView.register(MyPageLectureCell.self, forCellWithReuseIdentifier: MyPageLectureCell.identifier)
        self.collectionView.register(MyPageInfoCell.self, forCellWithReuseIdentifier: MyPageInfoCell.identifier)
        self.collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
    }
    
    private func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MyPageSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                if let classItem = item as? MyPageModel {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MyPageLectureCell.identifier,
                        for: indexPath
                    ) as! MyPageLectureCell
                    cell.configure(with: classItem)
                    return cell
                } else if let infoItem = item as? String {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MyPageInfoCell.identifier,
                        for: indexPath
                    ) as! MyPageInfoCell
                    cell.configure(with: infoItem)
                    return cell
                }
                return UICollectionViewCell()
            },
            configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: SectionHeaderView.identifier,
                        for: indexPath
                    ) as! SectionHeaderView
                    
                    let sectionModel = dataSource[indexPath.section]
                    header.configure(with: sectionModel.title)
                    
                    if indexPath.section == 0 {
                        header.onSeeAllTapped = { [weak self] in
                            self?.viewModel.classListSeeAllTappedRelay.accept(())
                        }
                    } else if indexPath.section == 1 {
                        header.onSeeAllTapped = { [weak self] in
                            self?.viewModel.bookmarkedSeeAllTappedRelay.accept(())
                        }
                    }
                    
                    return header
                }
                return UICollectionReusableView()
            }
        )
        
        let input = MyPageViewModel.Input(
            viewDidLoad: Observable.just(()),
            classListSeeAllTapped: viewModel.classListSeeAllTappedRelay.asObservable(),
            bookmarkedSeeAllTapped: viewModel.bookmarkedSeeAllTappedRelay.asObservable(),
            itemSelected: collectionView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        output.selectedClass
            .drive(with: self) { owner, classModel in
                print("셀 탭")
            }
            .disposed(by: disposeBag)
        
        output.navigateToAllClasses
            .drive(with: self) { owner, _ in
                let vc = LectureListViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.navigateToAllBookmarked
            .drive(with: self) { owner, _ in
                print("북마크")
            }
            .disposed(by: disposeBag)
    }
}

private extension MyPageViewController {
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex < 2 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(164),
                    heightDimension: .absolute(178)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(2),
                    heightDimension: .absolute(178)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 1
                section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0)
                
                return section
            }
        }
        return layout
    }
    
}
