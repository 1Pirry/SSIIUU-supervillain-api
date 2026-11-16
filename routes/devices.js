const express = require('express');
const router = express.Router({ mergeParams: true });
const Device = require('../models/Device');
const pick = require('../utils/pick');

const FIELDS = ['name', 'status', 'power'];

// Middleware: busca la máquina de la URL, comprobando que pertenece a la guarida (req.lair si está anidada)
function loadDevice(req, res, next) {
  const filter = req.lair ? { _id: req.params.deviceId, lair: req.lair._id } : { _id: req.params.deviceId };
  Device.findOne(filter)
    .then((device) => {
      if (!device) return res.status(404).json({ error: "Máquina no encontrada." });
      req.device = device;
      next();
    })
    .catch(next);
}

// GET: /villains/:villainId/lairs/:lairId/devices o GET /api/devices (inventario global securizado)
router.get('/', (req, res, next) => {
  const filter = req.lair ? { lair: req.lair._id } : {};
  Device.find(filter)
    .then((devices) => res.json({ message: "Armamento preparado", data: devices }))
    .catch(next);
});

// POST: construir una nueva máquina del juicio final
router.post('/', (req, res, next) => {
  const lairId = req.lair ? req.lair._id : req.body.lair;
  if (!lairId) return res.status(400).json({ error: "Debe indicarse la guarida (lair) de la máquina." });
  Device.create({ ...pick(req.body, FIELDS), lair: lairId })
    .then((device) => res.status(201).json({ message: "Nueva máquina del juicio final en construcción.", data: device }))
    .catch(next);
});

// GET: una máquina concreta
router.get('/:deviceId', loadDevice, (req, res) => {
  res.json(req.device);
});

// PUT: recalibrar una máquina
router.put('/:deviceId', loadDevice, (req, res, next) => {
  req.device.set(pick(req.body, FIELDS));
  req.device.save()
    .then((device) => res.json({ message: "Máquina recalibrada.", data: device }))
    .catch(next);
});

// DELETE: desmantelar una máquina
router.delete('/:deviceId', loadDevice, (req, res, next) => {
  req.device.deleteOne()
    .then(() => res.json({ message: "Máquina desmantelada. Qué pena." }))
    .catch(next);
});

module.exports = router;
