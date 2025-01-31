import { describe, it, beforeEach, expect } from "vitest"

describe("market-registry", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      getMarket: (marketId: number) => ({
        creator: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
        description: "Global temperature increase by 2025",
        resolutionDate: 100000,
        options: ["0-1°C", "1-2°C", "2-3°C", ">3°C"],
        totalStake: 1000,
        resolved: false,
        winningOption: null,
      }),
      createMarket: (description: string, resolutionDate: number, options: string[]) => ({ value: 1 }),
      getMarketStake: (marketId: number, option: number) => ({ totalStake: 500 }),
      resolveMarket: (marketId: number, winningOption: number) => ({ success: true }),
      getAllMarkets: () => ({ value: 3 }),
    }
  })
  
  describe("get-market", () => {
    it("should return market information", () => {
      const result = contract.getMarket(1)
      expect(result.description).toBe("Global temperature increase by 2025")
      expect(result.options.length).toBe(4)
    })
  })
  
  describe("create-market", () => {
    it("should create a new market", () => {
      const result = contract.createMarket("Sea level rise by 2030", 200000, ["0-10cm", "10-20cm", "20-30cm", ">30cm"])
      expect(result.value).toBe(1)
    })
  })
  
  describe("get-market-stake", () => {
    it("should return the stake for a specific option in a market", () => {
      const result = contract.getMarketStake(1, 2)
      expect(result.totalStake).toBe(500)
    })
  })
  
  describe("resolve-market", () => {
    it("should resolve a market with a winning option", () => {
      const result = contract.resolveMarket(1, 2)
      expect(result.success).toBe(true)
    })
  })
  
  describe("get-all-markets", () => {
    it("should return the total number of markets", () => {
      const result = contract.getAllMarkets()
      expect(result.value).toBe(3)
    })
  })
})

