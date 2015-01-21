local utils = require "apenode.tools.utils"
local Metric = require "apenode.models.metric"
local configuration = require "spec.unit.daos.sqlite.configuration"

local configuration, dao_factory = utils.load_configuration_and_dao(configuration)

describe("Metric Model", function()

  setup(function()
    dao_factory:prepare()
    dao_factory:seed(true)
  end)

  teardown(function()
    --dao_factory:drop()
    dao_factory:close()
  end)

  describe("#init()", function()
    it("should increment a model and retrieve it", function()

      local timestamps = utils.get_timestamps(os.time())

      local res, err = Metric.increment(1, 1, "requests", 2, dao_factory)
      assert.falsy(err)
      assert.truthy(res)

      local res, err = Metric.find_one({
                  api_id = 1,
                  application_id = 1,
                  name = "requests",
                  period = "second",
                  timestamp=timestamps.second}, dao_factory)

      assert.falsy(err)
      assert.truthy(res)
      assert.are.same(2, res.value)
    end)
  end)

end)
