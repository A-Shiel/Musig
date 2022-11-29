import UIKit

protocol LoginCellDelegate: AnyObject {
    func didTapButton(with title: String)
}


class LoginCell: UITableViewCell {
    
    public var btn: UIButton!
    private var title: String = ""
    weak var delegate: LoginCellDelegate?
    static let identifier = "LoginCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureBtn(with: title)
        contentView.addSubview(btn)
        btnConstraints()
        btn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureBtn(with: title)
    }
    
    private func btnConstraints() {
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        btn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        btn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        btn.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        delegate?.didTapButton(with: title)
    }
    
    func configureBtn(with title: String) {
        self.title = title
        btn = UIButton()
//        btn.configuration = .filled()
        btn.configuration = .filled()
        btn.tintColor = .tertiarySystemBackground
        btn.titleLabel?.font = .systemFont(ofSize: 40)
        btn.setTitle(title, for: .normal)
    }
}
