-- drop sequence
DROP SEQUENCE location_seq;
DROP SEQUENCE category_seq;
DROP SEQUENCE keyword_seq;
DROP SEQUENCE auction_master_seq;
DROP SEQUENCE member_seq;
DROP SEQUENCE payment_seq;
DROP SEQUENCE user_block_seq;
DROP SEQUENCE point_lock_seq;
DROP SEQUENCE direct_message_seq;
DROP SEQUENCE chat_room_seq;
DROP SEQUENCE wallet_history_seq;
DROP SEQUENCE withdraw_request_seq;
DROP SEQUENCE notification_seq;
DROP SEQUENCE auction_seq;
DROP SEQUENCE live_auction_seq;
DROP SEQUENCE direct_sale_seq;
DROP SEQUENCE bid_history_seq;
DROP SEQUENCE direct_message_log_seq;
DROP SEQUENCE chat_member_seq;
DROP SEQUENCE live_bid_history_seq;
DROP SEQUENCE trade_seq;
DROP SEQUENCE chat_log_seq;
DROP SEQUENCE trade_review_seq;


-- create sequence
CREATE SEQUENCE location_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE category_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE keyword_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE auction_master_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE member_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE user_block_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE point_lock_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE direct_message_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE chat_room_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE wallet_history_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE withdraw_request_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE notification_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE auction_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE live_auction_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE direct_sale_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE bid_history_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE direct_message_log_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE chat_member_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE live_bid_history_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE trade_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE chat_log_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE trade_review_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 1. 참조가 없는 최상위 테이블 생성
CREATE TABLE location (
    seq number NOT NULL,
    dong varchar2(20) NOT NULL,
    lat number(10,7) NULL,
    lng number(10,7) NULL,
    CONSTRAINT PK_LOCATION PRIMARY KEY (seq)
);

COMMENT ON COLUMN location.dong IS '카카오맵 좌표->주소변환 API';

CREATE TABLE category (
    seq number NOT NULL,
    name varchar2(20) NOT NULL,
    parent_seq number NULL,
    CONSTRAINT PK_CATEGORY PRIMARY KEY (seq),
    CONSTRAINT FK_category_TO_category_1 FOREIGN KEY (parent_seq) REFERENCES category (seq)
);

CREATE TABLE keyword (
    seq number NOT NULL,
    word varchar2(100) NOT NULL,
    regdate date DEFAULT sysdate NOT NULL,
    hit_count number DEFAULT 0 NOT NULL,
    CONSTRAINT PK_KEYWORD PRIMARY KEY (seq)
);

CREATE TABLE auction_master (
    seq number NOT NULL,
    type number(1) NOT NULL,
    CONSTRAINT PK_AUCTION_MASTER PRIMARY KEY (seq)
);

COMMENT ON COLUMN auction_master.type IS '일반경매(0), 라이브경매(1)';

-- 2. 최상위 테이블을 참조하는 테이블 생성
CREATE TABLE member (
    seq number NOT NULL,
    name varchar2(1000) NOT NULL,
    point number DEFAULT 0 NOT NULL,
    ID varchar2(1000) NOT NULL,
    PW varchar2(1000) NOT NULL,
    address varchar2(1000) NOT NULL,
    birth date NOT NULL,
    nickname varchar2(1000) NOT NULL,
    permission number DEFAULT 0 NOT NULL,
    regdate date DEFAULT sysdate NOT NULL,
    pw_token varchar2(1000) DEFAULT null NULL,
    token_expiry date DEFAULT null NULL,
    status number DEFAULT 0 NOT NULL,
    email_address varchar2(1000) NOT NULL,
    location_seq number NULL,
    CONSTRAINT PK_MEMBER PRIMARY KEY (seq),
    CONSTRAINT FK_location_TO_member_1 FOREIGN KEY (location_seq) REFERENCES location (seq)
);

COMMENT ON COLUMN member.ID IS 'unique';
COMMENT ON COLUMN member.nickname IS 'unique';
COMMENT ON COLUMN member.permission IS '0: 일반 회원, 1: 관리자';
COMMENT ON COLUMN member.pw_token IS 'unique';
COMMENT ON COLUMN member.status IS '0: 활성, 1: 비활성화';

-- 3. member 및 상위 테이블들을 참조하는 테이블 생성
CREATE TABLE payment (
    seq number NOT NULL,
    amount number NOT NULL,
    created_at date DEFAULT sysdate NOT NULL,
    transaction_key varchar2(255) NOT NULL,
    member_seq number NOT NULL,
    CONSTRAINT PK_PAYMENT PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_payment_1 FOREIGN KEY (member_seq) REFERENCES member (seq)
);

COMMENT ON COLUMN payment.transaction_key IS 'PG사 키';

CREATE TABLE user_block (
    seq number NOT NULL,
    reason varchar2(1000) NULL,
    block_date date DEFAULT sysdate NOT NULL,
    blocker_seq number NOT NULL,
    blocked_seq number NOT NULL,
    CONSTRAINT PK_USER_BLOCK PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_user_block_1 FOREIGN KEY (blocker_seq) REFERENCES member (seq),
    CONSTRAINT FK_member_TO_user_block_2 FOREIGN KEY (blocked_seq) REFERENCES member (seq)
);

CREATE TABLE point_lock (
    seq number NOT NULL,
    auction_type number(1) NOT NULL,
    auction_id number NOT NULL,
    amount number NULL,
    status number(1) NOT NULL,
    member_seq number NOT NULL,
    CONSTRAINT PK_POINT_LOCK PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_point_lock_1 FOREIGN KEY (member_seq) REFERENCES member (seq)
);

COMMENT ON COLUMN point_lock.auction_type IS '일반(0), 라이브(1)';
COMMENT ON COLUMN point_lock.status IS '잠김(0), 풀림(1), 사용(2)';

CREATE TABLE direct_message (
    seq          number NOT NULL,
    sender_seq   number NOT NULL,
    receiver_seq number NOT NULL,
    CONSTRAINT PK_DIRECT_MESSAGE PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_direct_message_1 FOREIGN KEY (sender_seq) REFERENCES member (seq),
    CONSTRAINT FK_member_TO_direct_message_2 FOREIGN KEY (receiver_seq) REFERENCES member (seq),
    CONSTRAINT CHK_NO_SELF_MESSAGE CHECK (sender_seq != receiver_seq)
);

-- 방향 무관 유니크 인덱스 (A→B와 B→A를 동일한 쌍으로 처리)
CREATE UNIQUE INDEX UQ_DIRECT_MESSAGE_PAIR
    ON direct_message (LEAST(sender_seq, receiver_seq), GREATEST(sender_seq, receiver_seq));

CREATE TABLE chat_room (
    seq number NOT NULL,
    title varchar2(100) NOT NULL,
    status number(1) DEFAULT 1 NOT NULL,
    max_member_cnt number DEFAULT 20 NOT NULL,
    current_member_cnt number DEFAULT 1 NOT NULL,
    category_seq number NOT NULL,
    member_seq number NOT NULL,
    CONSTRAINT PK_CHAT_ROOM PRIMARY KEY (seq),
    CONSTRAINT FK_category_TO_chat_room_1 FOREIGN KEY (category_seq) REFERENCES category (seq),
    CONSTRAINT FK_member_TO_chat_room_1 FOREIGN KEY (member_seq) REFERENCES member (seq)
);

COMMENT ON COLUMN chat_room.status IS '1:운영중/2:삭제';
COMMENT ON COLUMN chat_room.max_member_cnt IS '최대 50명까지 입장가능';
COMMENT ON COLUMN chat_room.current_member_cnt IS '채팅방참여자count';

CREATE TABLE wallet_history (
    seq number NOT NULL,
    amount number NOT NULL,
    point_after number NOT NULL,
    ref_type varchar2(30) NOT NULL,
    ref_id number NOT NULL,
    member_seq number NOT NULL,
    CONSTRAINT PK_WALLET_HISTORY PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_wallet_history_1 FOREIGN KEY (member_seq) REFERENCES member (seq)
);

CREATE TABLE withdraw_request (
    seq number NOT NULL,
    amount number NOT NULL,
    bank_name varchar2(30) NOT NULL,
    account_number varchar2(50) NOT NULL,
    account_holder varchar2(30) NOT NULL,
    status varchar2(30) DEFAULT '승인대기중' NOT NULL,
    member_seq number NOT NULL,
    CONSTRAINT PK_WITHDRAW_REQUEST PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_withdraw_request_1 FOREIGN KEY (member_seq) REFERENCES member (seq)
);

COMMENT ON COLUMN withdraw_request.seq IS '경매 락 금액 신경써야됨';

CREATE TABLE notification (
    seq number NOT NULL,
    message varchar2(255) NOT NULL,
    is_read varchar2(1) DEFAULT 'N' NOT NULL,
    created_at date DEFAULT sysdate NOT NULL,
    ref_type varchar2(50) NOT NULL,
    ref_seq number NOT NULL,
    member_seq number NOT NULL,
    CONSTRAINT PK_NOTIFICATION PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_notification_1 FOREIGN KEY (member_seq) REFERENCES member (seq)
);

CREATE TABLE auction (
    seq number NOT NULL,
    name varchar2(200) NOT NULL,
    bid_open_price number NOT NULL,
    image varchar2(500) DEFAULT 'default_image' NOT NULL,
    end_date date NOT NULL,
    description varchar2(1000) NOT NULL,
    created_at date DEFAULT sysdate NOT NULL,
    status number(1) NOT NULL,
    winner_seq number NULL,
    create_member_seq number NOT NULL,
    category_seq number NOT NULL,
    CONSTRAINT PK_AUCTION PRIMARY KEY (seq),
    CONSTRAINT FK_auction_master_TO_auction_1 FOREIGN KEY (seq) REFERENCES auction_master (seq),
    CONSTRAINT FK_member_TO_auction_1 FOREIGN KEY (winner_seq) REFERENCES member (seq),
    CONSTRAINT FK_member_TO_auction_2 FOREIGN KEY (create_member_seq) REFERENCES member (seq),
    CONSTRAINT FK_category_TO_auction_1 FOREIGN KEY (category_seq) REFERENCES category (seq)
);

COMMENT ON COLUMN auction.status IS '경매중(0), 낙찰(1), 유찰(2), 경매취소(3)';

CREATE TABLE live_auction (
    live_auction_seq number NOT NULL,
    name varchar2(200) NOT NULL,
    bid_open_price number NOT NULL,
    image varchar2(500) DEFAULT 'default_image' NOT NULL,
    end_time date NOT NULL,
    description varchar2(1000) NOT NULL,
    created_at date DEFAULT sysdate NOT NULL,
    status number(1) NOT NULL,
    current_high_price number NULL,
    winner_seq number NULL,
    create_member_seq number NOT NULL,
    CONSTRAINT PK_LIVE_AUCTION PRIMARY KEY (live_auction_seq),
    CONSTRAINT FK_auction_master_TO_live_auction_1 FOREIGN KEY (live_auction_seq) REFERENCES auction_master (seq),
    CONSTRAINT FK_member_TO_live_auction_1 FOREIGN KEY (winner_seq) REFERENCES member (seq),
    CONSTRAINT FK_member_TO_live_auction_2 FOREIGN KEY (create_member_seq) REFERENCES member (seq)
);

COMMENT ON COLUMN live_auction.status IS '경매중(0), 낙찰(1), 유찰(2), 경매취소(3)';

CREATE TABLE direct_sale (
    seq number NOT NULL,
    name varchar2(255) NOT NULL,
    description varchar2(4000) NOT NULL,
    status varchar2(20) DEFAULT '판매중' NOT NULL,
    meeting_place varchar2(255) NULL,
    product_name varchar2(255) NOT NULL,
    image_url varchar2(500) DEFAULT '/images/default-product.jpg' NOT NULL,
    price number NOT NULL,
    created_at date DEFAULT sysdate NOT NULL,
    seller_seq number NOT NULL,
    category_seq number NOT NULL,
    CONSTRAINT PK_DIRECT_SALE PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_direct_sale_1 FOREIGN KEY (seller_seq) REFERENCES member (seq),
    CONSTRAINT FK_category_TO_direct_sale_1 FOREIGN KEY (category_seq) REFERENCES category (seq)
);

COMMENT ON COLUMN direct_sale.meeting_place IS '거래 상세위치';

-- 4. 2차 참조 데이터 테이블 생성
CREATE TABLE highest_bid (
    live_auction_seq number NOT NULL,
    current_high_price number NULL,
    bidder_id varchar2(1000) NULL,
    CONSTRAINT PK_HIGHEST_BID PRIMARY KEY (live_auction_seq),
    CONSTRAINT FK_live_auction_TO_highest_bid_1 FOREIGN KEY (live_auction_seq) REFERENCES live_auction (live_auction_seq)
);

CREATE TABLE bid_history (
    seq number NOT NULL,
    bid_price number NOT NULL,
    bid_time date DEFAULT sysdate NOT NULL,
    status number(1) NOT NULL,
    member_seq number NOT NULL,
    auction_seq number NOT NULL,
    CONSTRAINT PK_BID_HISTORY PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_bid_history_1 FOREIGN KEY (member_seq) REFERENCES member (seq),
    CONSTRAINT FK_auction_TO_bid_history_1 FOREIGN KEY (auction_seq) REFERENCES auction (seq)
);

COMMENT ON COLUMN bid_history.status IS '정상(0), 취소(1)';

CREATE TABLE direct_message_log (
    seq                number        NOT NULL,
    content            varchar2(4000) NOT NULL,
    regdate            date          DEFAULT sysdate NOT NULL,
    sender_seq         number        NOT NULL,
    direct_message_seq number        NOT NULL,
    CONSTRAINT PK_DIRECT_MESSAGE_LOG PRIMARY KEY (seq),
    CONSTRAINT FK_direct_message_TO_direct_message_log_1 FOREIGN KEY (direct_message_seq) REFERENCES direct_message (seq),
    CONSTRAINT FK_member_TO_direct_message_log_1 FOREIGN KEY (sender_seq) REFERENCES member (seq)
);

CREATE TABLE chat_member (
    Key number NOT NULL,
    last_read_message number NOT NULL,
    alarm number DEFAULT 0 NOT NULL,
    status number DEFAULT 1 NOT NULL,
    member_seq number NOT NULL,
    chat_room_seq number NOT NULL,
    CONSTRAINT PK_CHAT_MEMBER PRIMARY KEY (Key),
    CONSTRAINT FK_member_TO_chat_member_1 FOREIGN KEY (member_seq) REFERENCES member (seq),
    CONSTRAINT FK_chat_room_TO_chat_member_1 FOREIGN KEY (chat_room_seq) REFERENCES chat_room (seq)
);

COMMENT ON COLUMN chat_member.last_read_message IS '테이블X논리적인 외래키(채팅방 내역의 seq)';
COMMENT ON COLUMN chat_member.alarm IS '0:알림 무시 상태 / 1: 알림을 받는 상태';
COMMENT ON COLUMN chat_member.status IS '0:상시오프라인/1:온라인/2:다른일/3:오프라인';

CREATE TABLE live_bid_history (
    seq number NOT NULL,
    bid_price number NOT NULL,
    bid_time date DEFAULT sysdate NOT NULL,
    member_seq number NOT NULL,
    live_auction_seq number NOT NULL,
    CONSTRAINT PK_LIVE_BID_HISTORY PRIMARY KEY (seq),
    CONSTRAINT FK_member_TO_live_bid_history_1 FOREIGN KEY (member_seq) REFERENCES member (seq),
    CONSTRAINT FK_live_auction_TO_live_bid_history_1 FOREIGN KEY (live_auction_seq) REFERENCES live_auction (live_auction_seq)
);

CREATE TABLE trade (
    seq number NOT NULL,
    status varchar2(30) DEFAULT '확인요청중' NOT NULL,
    created_at date DEFAULT sysdate NOT NULL,
    completed_at date NULL,
    direct_sale_seq number NOT NULL,
    buyer_seq number NOT NULL,
    seller_seq number NOT NULL,
    CONSTRAINT PK_TRADE PRIMARY KEY (seq),
    CONSTRAINT FK_direct_sale_TO_trade_1 FOREIGN KEY (direct_sale_seq) REFERENCES direct_sale (seq),
    CONSTRAINT FK_member_TO_trade_1 FOREIGN KEY (buyer_seq) REFERENCES member (seq),
    CONSTRAINT FK_member_TO_trade_2 FOREIGN KEY (seller_seq) REFERENCES member (seq)
);

-- 5. 3차 참조 데이터 테이블 생성
CREATE TABLE chat_log (
    seq number NOT NULL,
    content varchar2(4000) NOT NULL,
    regdate date DEFAULT sysdate NOT NULL,
    type number NOT NULL,
    chat_member_seq number NOT NULL,
    chat_room_seq number NOT NULL,
    CONSTRAINT PK_CHAT_LOG PRIMARY KEY (seq),
    CONSTRAINT FK_chat_member_TO_chat_log_1 FOREIGN KEY (chat_member_seq) REFERENCES chat_member (Key),
    CONSTRAINT FK_chat_room_TO_chat_log_1 FOREIGN KEY (chat_room_seq) REFERENCES chat_room (seq)
);

COMMENT ON COLUMN chat_log.type IS '1:전체 2:공지 3:입찰 4:이모티콘';
COMMENT ON COLUMN chat_log.chat_member_seq IS '채팅한사람';

CREATE TABLE trade_review (
    seq number NOT NULL,
    trade_seq number NOT NULL,
    seller_seq number NOT NULL,
    buyer_seq number NOT NULL,
    score number NOT NULL,
    CONSTRAINT PK_TRADE_REVIEW PRIMARY KEY (seq),
    CONSTRAINT FK_trade_TO_trade_review_1 FOREIGN KEY (trade_seq) REFERENCES trade (seq),
    CONSTRAINT FK_member_TO_trade_review_1 FOREIGN KEY (seller_seq) REFERENCES member (seq),
    CONSTRAINT FK_member_TO_trade_review_2 FOREIGN KEY (buyer_seq) REFERENCES member (seq)
);
