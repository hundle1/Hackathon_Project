// Hợp đồng NFT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTTrial is ERC721 {
    // Biến lưu trữ thời gian thử nghiệm (tính bằng giây)
    uint256 public trialPeriod;

    // Biến lưu trữ thời điểm bắt đầu thử nghiệm
    mapping(uint256 => uint256) public trialStartTimes;

    // Sự kiện khi NFT được bán với thời gian thử nghiệm
    event NFTTrialStarted(uint256 tokenId, address buyer, uint256 trialPeriod);

    // Sự kiện khi NFT được trả lại và giao dịch được hủy
    event NFTTrialRefunded(uint256 tokenId, address buyer);

    // Hàm khởi tạo hợp đồng
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        trialPeriod = 3 days; // Thời gian thử nghiệm mặc định là 3 ngày
    }

    // Hàm bán NFT với thời gian thử nghiệm
    function sellWithTrial(
        uint256 tokenId,
        address buyer,
        uint256 newTrialPeriod
    ) public {
        require(
            msg.sender == ownerOf(tokenId),
            "Only the owner can sell the NFT"
        );
        require(newTrialPeriod > 0, "Trial period must be greater than zero");

        // Chuyển NFT sang người mua
        _transfer(msg.sender, buyer, tokenId);

        // Lưu trữ thời gian bắt đầu thử nghiệm
        trialStartTimes[tokenId] = block.timestamp;

        // Cập nhật thời gian thử nghiệm mới
        trialPeriod = newTrialPeriod;

        // Kích hoạt sự kiện NFTTrialStarted
        emit NFTTrialStarted(tokenId, buyer, newTrialPeriod);
    }

    // Hàm kiểm tra xem NFT có đang trong thời gian thử nghiệm hay không
    function isNFTInTrial(uint256 tokenId) public view returns (bool) {
        uint256 startTime = trialStartTimes[tokenId];
        return startTime != 0 && block.timestamp < startTime + trialPeriod;
    }

    // Hàm cho phép người mua trả lại NFT và hủy giao dịch
    function refundNFT(uint256 tokenId) public {
        require(isNFTInTrial(tokenId), "NFT is not in trial period");
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the owner can refund the NFT"
        );

        // Chuyển NFT lại cho người bán
        _transfer(msg.sender, address(this), tokenId);

        // Xóa thông tin thời gian thử nghiệm
        delete trialStartTimes[tokenId];

        // Kích hoạt sự kiện NFTTrialRefunded
        emit NFTTrialRefunded(tokenId, msg.sender);
    }

    // Hàm cho phép người bán chỉnh sửa thời gian thử nghiệm
    function setTrialPeriod(uint256 newTrialPeriod) public onlyOwner {
        require(newTrialPeriod > 0, "Trial period must be greater than zero");
        trialPeriod = newTrialPeriod;
    }
}
