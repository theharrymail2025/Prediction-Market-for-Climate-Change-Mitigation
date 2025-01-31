;; Market Registry Contract

(define-map markets
  { market-id: uint }
  {
    creator: principal,
    description: (string-utf8 500),
    resolution-date: uint,
    options: (list 10 (string-ascii 50)),
    total-stake: uint,
    resolved: bool,
    winning-option: (optional uint)
  }
)

(define-map market-stakes
  { market-id: uint, option: uint }
  { total-stake: uint }
)

(define-data-var market-id-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u403))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_INVALID_INPUT (err u400))

(define-read-only (get-market (market-id uint))
  (map-get? markets { market-id: market-id })
)

(define-public (create-market (description (string-utf8 500)) (resolution-date uint) (options (list 10 (string-ascii 50))))
  (let
    ((new-market-id (+ (var-get market-id-nonce) u1)))
    (asserts! (> (len options) u0) ERR_INVALID_INPUT)
    (asserts! (< (len options) u11) ERR_INVALID_INPUT)
    (asserts! (> resolution-date block-height) ERR_INVALID_INPUT)
    (map-set markets
      { market-id: new-market-id }
      {
        creator: tx-sender,
        description: description,
        resolution-date: resolution-date,
        options: options,
        total-stake: u0,
        resolved: false,
        winning-option: none
      }
    )
    (var-set market-id-nonce new-market-id)
    (ok new-market-id)
  )
)

(define-read-only (get-market-stake (market-id uint) (option uint))
  (default-to { total-stake: u0 } (map-get? market-stakes { market-id: market-id, option: option }))
)

(define-public (resolve-market (market-id uint) (winning-option uint))
  (let
    ((market (unwrap! (get-market market-id) ERR_NOT_FOUND)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (not (get resolved market)) ERR_INVALID_INPUT)
    (asserts! (>= block-height (get resolution-date market)) ERR_INVALID_INPUT)
    (asserts! (< winning-option (len (get options market))) ERR_INVALID_INPUT)
    (map-set markets
      { market-id: market-id }
      (merge market { resolved: true, winning-option: (some winning-option) })
    )
    (ok true)
  )
)

(define-read-only (get-all-markets)
  (ok (var-get market-id-nonce))
)

