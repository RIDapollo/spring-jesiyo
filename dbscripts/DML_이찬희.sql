-- 카테고리
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '전자기기', NULL);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '음향기기', 1);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '헤드폰', 2);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '스피커', 2);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '컴퓨터', 1);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '램', 5);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, 'CPU', 5);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '그래픽카드', 5);

INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '핸드폰', 1);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '케이스', 9);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '액정필름', 9);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '카드케이스', 9);

INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, 'TV', 1);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '벽걸이TV', 13);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '스탠드TV', 13);

INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '에어컨', 1);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '벽걸이에어컨', 16);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '스탠드에어컨', 16);

INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '생활용품', null);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '주방용품', 19);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '세제', 20);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '도마', 20);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '칼', 20);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '주방가위', 20);

INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '청소용품', 19);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '청소기', 25);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '로봇청소기', 25);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '세탁기', 25);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '건조기', 25);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '스타일러', 25);


INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '의류', null);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '상의', 31);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '반팔', 32);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '니트', 32);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '긴팔', 32);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '맨투맨', 32);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '셔츠', 32);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '아우터', 31);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '패딩', 43);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '코트', 43);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '후리스', 43);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '후드', 43);

INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '신발', 31);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '슬리퍼', 48);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '운동화', 48);
INSERT INTO category (seq, name, parent_seq) VALUES (category_seq.nextval, '구두', 48);

SELECT * FROM category order by seq desc;

-- 동네
INSERT INTO location (seq, dong, lat, lng) VALUES (location_seq.nextval, '정자동', 37.3663381, 127.1060271);
INSERT INTO location (seq, dong, lat, lng) VALUES (location_seq.nextval, '서현동', 37.3851032, 127.1234198);
INSERT INTO location (seq, dong, lat, lng) VALUES (location_seq.nextval, '수내동', 37.3785110, 127.1143215);
INSERT INTO location (seq, dong, lat, lng) VALUES (location_seq.nextval, '야탑동', 37.4112345, 127.1287654);
INSERT INTO location (seq, dong, lat, lng) VALUES (location_seq.nextval, '분당동', 37.3678912, 127.1478910);

SELECT * FROM location;

-- 중고거래
INSERT INTO direct_sale VALUES (direct_sale_seq.nextval,'급처합니다','생활기스 있음','완료','정자동 카페 앞','아이폰 13','/images/default-product.jpg',450000,SYSDATE,1,3);
INSERT INTO direct_sale VALUES (direct_sale_seq.nextval,'노트북 판매','초기화 완료','완료','서현역 5번출구','삼성 노트북','/images/default-product.jpg',650000,SYSDATE,1,4);
INSERT INTO direct_sale VALUES (direct_sale_seq.nextval,'자전거 팝니다','상태 양호','판매중','야탑역 앞','알톤 자전거','/images/default-product.jpg',120000,SYSDATE,1,3);
INSERT INTO direct_sale VALUES (direct_sale_seq.nextval,'의자 거의 새것','사용감 거의 없음','판매중','수내동 공원','사무용 의자','/images/default-product.jpg',30000,SYSDATE,1,4);

SELECT * FROM direct_sale;

-- 중고거래 결과
INSERT INTO trade
(seq, status, created_at, completed_at, direct_sale_seq, buyer_seq, seller_seq) VALUES
(trade_seq.nextval, '완료', TO_DATE('2026-04-22 02:10:00','YYYY-MM-DD HH24:MI:SS'), TO_DATE('2026-04-22 03:00:00','YYYY-MM-DD HH24:MI:SS'), 1, 2, 1);
INSERT INTO trade
(seq, status, created_at, completed_at, direct_sale_seq, buyer_seq, seller_seq) VALUES
(trade_seq.nextval, '완료', TO_DATE('2026-04-22 02:15:00','YYYY-MM-DD HH24:MI:SS'), TO_DATE('2026-04-22 10:15:00','YYYY-MM-DD HH24:MI:SS'), 2, 2, 1);
INSERT INTO trade
(seq, status, created_at, completed_at, direct_sale_seq, buyer_seq, seller_seq) VALUES
(trade_seq.nextval, '확인요청중', TO_DATE('2026-04-22 02:20:00','YYYY-MM-DD HH24:MI:SS'), NULL, 3, 2, 1);

SELECT * FROM trade;

-- 결제(포인트 충전)
INSERT INTO payment VALUES (payment_seq.nextval, 50000, SYSDATE, 'PAY_20260422_0001', 1);
INSERT INTO payment VALUES (payment_seq.nextval, 100000, SYSDATE, 'PAY_20260422_0002', 1);
INSERT INTO payment VALUES (payment_seq.nextval, 30000, SYSDATE, 'PAY_20260422_0003', 1);
INSERT INTO payment VALUES (payment_seq.nextval, 70000, SYSDATE, 'PAY_20260422_0004', 1);
INSERT INTO payment VALUES (payment_seq.nextval, 20000, SYSDATE, 'PAY_20260422_0005', 1);

SELECT * FROM PAYMENT;

-- 출금요청
INSERT INTO withdraw_request VALUES (withdraw_request_seq.nextval, 30000, '국민은행', '111-222-3333', '홍길동', '출금완료', 1);
INSERT INTO withdraw_request VALUES (withdraw_request_seq.nextval, 50000, '신한은행', '444-555-6666', '홍길동', '승인대기중', 1);

SELECT * FROM WITHDRAW_REQUEST;

-- 입출금내역
INSERT INTO wallet_history VALUES (wallet_history_seq.nextval, 50000, 50000, 'PAYMENT', 1, 1);
INSERT INTO wallet_history VALUES (wallet_history_seq.nextval, 100000, 150000, 'PAYMENT', 2, 1);
INSERT INTO wallet_history VALUES (wallet_history_seq.nextval, 30000, 180000, 'PAYMENT', 3, 1);
INSERT INTO wallet_history VALUES (wallet_history_seq.nextval, 70000, 250000, 'PAYMENT', 4, 1);
INSERT INTO wallet_history VALUES (wallet_history_seq.nextval, 20000, 270000, 'PAYMENT', 5, 1);
INSERT INTO wallet_history VALUES (wallet_history_seq.nextval, 30000, 240000, 'WITHDRAW', 1, 1);

SELECT * FROM WALLET_HISTORY;

-- 알림
INSERT INTO notification VALUES (notification_seq.nextval, '입찰하신 상품에 새로운 입찰이 들어왔습니다.', 'N', SYSDATE, 'AUCTION', 1, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '경매가 곧 종료됩니다. 서둘러 확인해주세요.', 'N', SYSDATE, 'AUCTION', 2, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '낙찰되었습니다! 결제를 진행해주세요.', 'Y', SYSDATE, 'AUCTION', 3, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '중고거래 요청이 도착했습니다.', 'N', SYSDATE, 'DIRECT', 1, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '거래 상대방이 채팅을 시작했습니다.', 'Y', SYSDATE, 'DIRECT', 2, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '거래가 완료되었습니다. 후기 작성을 해주세요.', 'N', SYSDATE, 'DIRECT', 3, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '새 메시지가 도착했습니다.', 'N', SYSDATE, 'CHAT', 1, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '채팅방에 새로운 사용자가 참여했습니다.', 'Y', SYSDATE, 'CHAT', 2, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '시스템 점검이 예정되어 있습니다.', 'N', SYSDATE, 'OTHER', 1, 1);
INSERT INTO notification VALUES (notification_seq.nextval, '포인트 충전이 완료되었습니다.', 'Y', SYSDATE, 'OTHER', 2, 1);

SELECT * FROM notification order by seq desc ;

